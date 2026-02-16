import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles
from .models import BCIngestPayload, GenerateRequest, GenerateResponse, Client, TravelService, Reservation
from .ai import generate_itinerary
from .bc_client import BCClient
from dotenv import load_dotenv

load_dotenv(os.path.join(os.path.dirname(__file__), ".env"))
load_dotenv(os.path.join(os.path.dirname(os.path.dirname(__file__)), ".env"))

app = FastAPI(title="ERP-AI Integration")

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


@app.post("/bc/ingest")
def bc_ingest(payload: BCIngestPayload):
    return {"status": "ok", "client": payload.client.id, "reservation": payload.reservation.reservation_no, "services": len(payload.services)}


@app.post("/generate", response_model=GenerateResponse)
def generate(req: GenerateRequest):
    return generate_itinerary(req)


@app.post("/generate/from_bc", response_model=GenerateResponse)
def generate_from_bc(client_id: str, days: int | None = None, company_name: str | None = None):
    bc = BCClient(company_name=company_name)
    cid = bc.company_id()
    if not cid:
        return generate_itinerary(GenerateRequest(client=Client(id=client_id, name="Unknown"), reservation=Reservation(reservation_no="N/A", client_id=client_id), services=[], days=days))
    c = bc.travel_client(cid, client_id)
    rs = bc.reservations_for_client(cid, client_id)
    svcs_all = {s.get("code"): s for s in bc.travel_services(cid)}
    chosen = []
    for r in rs:
        code = r.get("serviceCode")
        if code and code in svcs_all:
            chosen.append(svcs_all[code])
    if not chosen:
        chosen = list(svcs_all.values())
    cli = Client(id=client_id, name=(c or {}).get("name", client_id), preferences=(c or {}).get("aiPreferences"))
    res = Reservation(reservation_no=(rs[0].get("reservationNo") if rs else "N/A"), client_id=client_id, status=(rs[0].get("status") if rs else None))
    services = []
    for s in chosen:
        services.append(TravelService(code=s.get("code"), name=s.get("name"), destination=s.get("destination"), type=s.get("serviceType"), price=s.get("price"), currency=s.get("currencyCode"), latitude=s.get("latitude"), longitude=s.get("longitude"), description=s.get("longDescription") or s.get("description")))
    return generate_itinerary(GenerateRequest(client=cli, reservation=res, services=services, days=days))

@app.get("/demo/itinerary", response_model=GenerateResponse)
def demo_itinerary():
    demo = {
        "client": {"id": "CL001", "name": "Ahmed Ben Salem"},
        "reservation": {"reservation_no": "R001", "client_id": "CL001", "status": "Confirmed"},
        "services": [
            {"code": "TS001", "name": "The Residence", "destination": "Gammarth", "type": "Hotel", "latitude": 36.9180, "longitude": 10.2860},
            {"code": "TS015", "name": "Musée National du Bardo", "destination": "Tunis", "type": "Activity", "latitude": 36.8093, "longitude": 10.1345},
            {"code": "TS018", "name": "Carthage Ruins", "destination": "Carthage", "type": "Activity", "latitude": 36.8525, "longitude": 10.3233}
        ],
        "days": 2
    }
    req = GenerateRequest(**demo)
    return generate_itinerary(req)
