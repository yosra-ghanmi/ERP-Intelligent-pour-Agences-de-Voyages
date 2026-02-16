from datetime import date
from typing import List, Optional
from pydantic import BaseModel


class Client(BaseModel):
    id: str
    name: str
    preferences: Optional[str] = None
    preferences : str


class TravelService(BaseModel):
    code: Optional[str] = None
    name: Optional[str] = None
    destination: Optional[str] = None
    type: Optional[str] = None
    price: Optional[float] = None
    currency: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    description: Optional[str] = None


class Reservation(BaseModel):
    reservation_no: str
    client_id: str
    service_code: Optional[str] = None
    reservation_date: Optional[date] = None
    status: Optional[str] = None


class BCIngestPayload(BaseModel):
    client: Client
    reservation: Reservation
    services: List[TravelService]


class ItineraryItem(BaseModel):
    title: str
    description: str
    latitude: float
    longitude: float


class ItineraryDay(BaseModel):
    day: int
    items: List[ItineraryItem]


class GenerateRequest(BaseModel):
    client: Client
    reservation: Reservation
    services: List[TravelService]
    days: Optional[int] = None


class GenerateResponse(BaseModel):
    client_id: str
    reservation_no: str
    days: List[ItineraryDay]
    source: str
