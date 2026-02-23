from datetime import date
from typing import List, Optional
from pydantic import BaseModel, Field


class Client(BaseModel):
    id: str = Field(..., description="Client unique identifier")
    name: str = Field(..., description="Client full name")
    preferences: Optional[str] = Field(None, description="Client travel preferences")


class TravelService(BaseModel):
    code: Optional[str] = Field(None, description="Service code")
    name: Optional[str] = Field(None, description="Service name")
    destination: Optional[str] = Field(None, description="Destination location")
    type: Optional[str] = Field(None, alias="serviceType", description="Service type")
    price: Optional[float] = Field(None, description="Price")
    currency: Optional[str] = Field(None, description="Currency code")
    latitude: Optional[float] = Field(None, description="GPS latitude")
    longitude: Optional[float] = Field(None, description="GPS longitude")
    description: Optional[str] = Field(None, description="Service description")

    class Config:
        populate_by_name = True


class Reservation(BaseModel):
    reservation_no: str = Field(..., alias="reservationNo", description="Reservation number")
    client_id: str = Field(..., alias="clientId", description="Client ID")
    service_code: Optional[str] = Field(None, alias="serviceCode", description="Service code")
    reservation_date: Optional[date] = Field(None, alias="reservationDate", description="Reservation date")
    status: Optional[str] = Field(None, description="Reservation status")

    class Config:
        populate_by_name = True


class BCIngestPayload(BaseModel):
    client: Client
    reservation: Reservation
    services: List[TravelService]


class ItineraryItem(BaseModel):
    time: Optional[str] = Field(None, description="Estimated time (e.g., 09:00)")
    title: str
    description: str
    location: Optional[str] = Field(None, description="Place name")
    latitude: float
    longitude: float
    tips: Optional[str] = Field(None, description="Local tips")


class ItineraryDay(BaseModel):
    day: int
    theme: Optional[str] = Field(None, description="Theme of the day")
    items: List[ItineraryItem]


class GenerateRequest(BaseModel):
    client: Client
    reservation: Reservation
    services: List[TravelService] = Field(default_factory=list)
    days: Optional[int] = Field(None, description="Number of days for itinerary")


class GenerateResponse(BaseModel):
    client_id: str = Field(..., alias="clientId")
    reservation_no: str = Field(..., alias="reservationNo")
    title: Optional[str] = Field(None, description="Itinerary Title")
    summary: Optional[str] = Field(None, description="Brief overview")
    days: List[ItineraryDay]
    recommendations: Optional[List[str]] = Field(None, description="General recommendations")
    source: str = Field(..., description="Source of generation: 'ai' or 'fallback'")

    class Config:
        populate_by_name = True
