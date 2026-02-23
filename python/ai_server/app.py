import os
import logging
from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse, JSONResponse
from fastapi.staticfiles import StaticFiles
from models import BCIngestPayload, GenerateRequest, GenerateResponse, Client, TravelService, Reservation
from ai import generate_itinerary
from bc_client import BCClient
from dotenv import load_dotenv

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

load_dotenv(os.path.join(os.path.dirname(__file__), ".env"))
load_dotenv(os.path.join(os.path.dirname(os.path.dirname(__file__)), ".env"))

app = FastAPI(
    title="ERP-AI Integration",
    description="AI-powered itinerary generation for Travel Agency ERP",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

static_dir = os.path.join(os.path.dirname(__file__), "static")
if os.path.isdir(static_dir):
    app.mount("/static", StaticFiles(directory=static_dir, html=True), name="static")


@app.get("/")
def root():
    return RedirectResponse(url="/static/map.html")


@app.get("/health")
def health_check():
    return {"status": "healthy", "service": "ERP-AI Integration"}


@app.post("/bc/ingest")
def bc_ingest(payload: BCIngestPayload):
    logger.info(f"Received BC ingest for client: {payload.client.id}")
    return {
        "status": "ok", 
        "client": payload.client.id, 
        "reservation": payload.reservation.reservation_no, 
        "services": len(payload.services)
    }


@app.post("/generate", response_model=GenerateResponse)
def generate(req: GenerateRequest):
    logger.info(f"Generate itinerary for client: {req.client.id}, reservation: {req.reservation.reservation_no}")
    try:
        result = generate_itinerary(req)
        logger.info(f"Generated {len(result.days)} days itinerary (source: {result.source})")
        return result
    except Exception as e:
        logger.error(f"Error generating itinerary: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/generate/from_bc", response_model=GenerateResponse)
def generate_from_bc(client_id: str, days: int | None = None, company_name: str | None = None):
    try:
        bc = BCClient(company_name=company_name)
        c = bc.travel_client(client_id)
        rs = bc.reservations_for_client(client_id)
        svcs_all = {s.get("code"): s for s in bc.travel_services()}
        
        chosen = []
        for r in rs:
            code = r.get("serviceCode")
            if code and code in svcs_all:
                chosen.append(svcs_all[code])
        
        if not chosen:
            chosen = list(svcs_all.values())
            
        cli = Client(
            id=client_id, 
            name=(c or {}).get("name", client_id), 
            preferences=(c or {}).get("aiPreferences")
        )
        
        res = Reservation(
            reservation_no=(rs[0].get("reservationNo") if rs else "N/A"), 
            client_id=client_id, 
            status=(rs[0].get("status") if rs else None)
        )
        
        services = []
        for s in chosen:
            services.append(TravelService(
                code=s.get("code"), 
                name=s.get("name"), 
                destination=s.get("destination"), 
                type=s.get("serviceType"), 
                price=s.get("price"), 
                currency=s.get("currencyCode"), 
                latitude=s.get("latitude"), 
                longitude=s.get("longitude"), 
                description=s.get("longDescription") or s.get("description")
            ))
            
        return generate_itinerary(GenerateRequest(client=cli, reservation=res, services=services, days=days))
    except Exception as e:
        logger.error(f"Error fetching from BC: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/services/locations")
def get_services_locations(company_name: str | None = None):
    try:
        bc = BCClient(company_name=company_name)
        services = bc.travel_services()
        return {"services": services}
    except Exception as e:
        logger.error(f"Error fetching services: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/itinerary/{reservation_no}", response_model=GenerateResponse)
def get_itinerary(reservation_no: str, days: int | None = None, company_name: str | None = None):
    try:
        bc = BCClient(company_name=company_name)
        res_data = bc.reservation(reservation_no)
        if not res_data:
            raise HTTPException(status_code=404, detail=f"Reservation {reservation_no} not found")
            
        client_id = res_data.get("clientNo")
        if not client_id:
            raise HTTPException(status_code=400, detail="Reservation has no client associated")
            
        return generate_from_bc(client_id=client_id, days=days, company_name=company_name)
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching itinerary for reservation {reservation_no}: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/demo/itinerary", response_model=GenerateResponse)
def demo_itinerary():
    demo = {
        "client": {"id": "CL001", "name": "Ahmed Ben Salem"},
        "reservation": {"reservationNo": "R001", "clientId": "CL001", "status": "Confirmed"},
        "services": [
            {"code": "TS001", "name": "The Residence", "destination": "Gammarth", "serviceType": "Hotel", "latitude": 36.9180, "longitude": 10.2860},
            {"code": "TS015", "name": "Musée National du Bardo", "destination": "Tunis", "serviceType": "Activity", "latitude": 36.8093, "longitude": 10.1345},
            {"code": "TS018", "name": "Carthage Ruins", "destination": "Carthage", "serviceType": "Activity", "latitude": 36.8525, "longitude": 10.3233}
        ],
        "days": 2
    }
    req = GenerateRequest(**demo)
    return generate_itinerary(req)


@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled exception: {exc}")
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error", "error": str(exc)}
    )
