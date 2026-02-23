import os
from typing import Dict, List, Optional
from urllib.parse import quote
import requests
from requests.auth import HTTPBasicAuth
try:
    from requests_ntlm import HttpNtlmAuth  # type: ignore
except Exception:
    HttpNtlmAuth = None  # type: ignore


from requests_negotiate_sspi import HttpNegotiateAuth

class BCClient:
    def __init__(self, base_url: Optional[str] = None, company_name: Optional[str] = None):
        self.base_url = base_url or os.getenv("BC_BASE_URL", "http://localhost:7048/BC250")
        self.company_name = company_name or os.getenv("BC_COMPANY_NAME", "smart travel agency")
        self.auth_mode = os.getenv("BC_AUTH", "basic").lower()
        self.username = os.getenv("BC_USERNAME", "")
        self.password = os.getenv("BC_PASSWORD", "")
        self.session = requests.Session()
        self.session.headers.update({"Content-Type": "application/json"})

    def _auth(self):
        if self.auth_mode == "sspi":
            return HttpNegotiateAuth()
        if self.auth_mode in ("ntlm", "windows") and HttpNtlmAuth:
            return HttpNtlmAuth(self.username, self.password)  # type: ignore
        return HTTPBasicAuth(self.username, self.password)

    def _api_root(self) -> str:
        return f"{self.base_url}/ODataV4"

    def _company_root(self) -> str:
        company_encoded = quote(self.company_name, safe="")
        return f"{self._api_root()}/Company('{company_encoded}')"

    def travel_services(self) -> List[Dict]:
        r = self.session.get(f"{self._company_root()}/TravelServiceAPI", auth=self._auth(), timeout=20)
        r.raise_for_status()
        return r.json().get("value", [])

    def travel_client(self, client_no: str) -> Optional[Dict]:
        url = f"{self._company_root()}/TravelClientAPI?$filter=no eq '{client_no}'"
        r = self.session.get(url, auth=self._auth(), timeout=20)
        r.raise_for_status()
        arr = r.json().get("value", [])
        return arr[0] if arr else None

    def reservations_for_client(self, client_no: str) -> List[Dict]:
        url = f"{self._company_root()}/TravelReservationAPI?$filter=clientNo eq '{client_no}'"
        r = self.session.get(url, auth=self._auth(), timeout=20)
        r.raise_for_status()
        return r.json().get("value", [])

    def reservation(self, reservation_no: str) -> Optional[Dict]:
        url = f"{self._company_root()}/TravelReservationAPI?$filter=reservationNo eq '{reservation_no}'"
        r = self.session.get(url, auth=self._auth(), timeout=20)
        r.raise_for_status()
        arr = r.json().get("value", [])
        return arr[0] if arr else None
