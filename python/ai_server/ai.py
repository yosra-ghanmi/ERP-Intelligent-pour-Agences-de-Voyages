import os
from typing import List
from .models import GenerateRequest, GenerateResponse, ItineraryDay, ItineraryItem


def generate_with_llm(prompt: str) -> str:
    provider = os.getenv("AI_PROVIDER", "").lower()
    if provider == "openai" and os.getenv("OPENAI_API_KEY"):
        try:
            from openai import OpenAI
            client = OpenAI()
            r = client.chat.completions.create(
                model=os.getenv("OPENAI_MODEL", "gpt-4o-mini"),
                messages=[{"role": "system", "content": "You generate travel itineraries."},
                          {"role": "user", "content": prompt}],
                temperature=0.7,
                max_tokens=300
            )
            return r.choices[0].message.content.strip()
        except Exception:
            pass
    if provider == "gemini" and os.getenv("GEMINI_API_KEY"):
        try:
            import google.generativeai as genai
            genai.configure(api_key=os.environ["GEMINI_API_KEY"])
            model = genai.GenerativeModel(os.getenv("GEMINI_MODEL", "gemini-1.5-flash"))
            r = model.generate_content(prompt)
            return r.text.strip()
        except Exception:
            pass
    return ""


def _fallback_itinerary(req: GenerateRequest, source: str = "fallback") -> GenerateResponse:
    items: List[ItineraryDay] = []
    n = max(1, req.days or len(req.services) or 1)
    per_day = max(1, (len(req.services) + n - 1) // n)
    day = 1
    buf: List[ItineraryItem] = []
    for idx, s in enumerate(req.services):
        lat = float(s.latitude or 0.0)
        lon = float(s.longitude or 0.0)
        title = s.name or s.destination or s.code or f"Stop {idx+1}"
        desc = s.description or f"{s.type or 'Service'} in {s.destination or s.name or ''}".strip()
        buf.append(ItineraryItem(title=title, description=desc, latitude=lat, longitude=lon))
        if len(buf) >= per_day:
            items.append(ItineraryDay(day=day, items=list(buf)))
            buf.clear()
            day += 1
    if buf:
        items.append(ItineraryDay(day=day, items=list(buf)))
    return GenerateResponse(client_id=req.client.id, reservation_no=req.reservation.reservation_no, days=items, source=source)


def generate_itinerary(req: GenerateRequest) -> GenerateResponse:
    parts = []
    parts.append(f"Client: {req.client.name} ({req.client.id})")
    if req.client.preferences:
        parts.append(f"Preferences: {req.client.preferences}")
    parts.append(f"Reservation: {req.reservation.reservation_no} Status: {req.reservation.status or ''}")
    for s in req.services:
        parts.append(f"{s.name or s.destination or s.code or ''} | {s.type or ''} | {s.latitude},{s.longitude}")
    prompt = "\n".join(parts)
    text = generate_with_llm(prompt)
    if not text:
        return _fallback_itinerary(req, source="fallback")
    return _fallback_itinerary(req, source="ai")
