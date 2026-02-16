import os
from typing import Dict, List, Optional
import requests
from requests.auth import HTTPBasicAuth
try:
    from requests_ntlm import HttpNtlmAuth  # type: ignore
except Exception:
    HttpNtlmAuth = None  # type: ignore


class BCClient:
    def __init__(self, base_url: Optional[str] = None, company_name: Optional[str] = None):
        self.base_url = base_url or os.getenv("BC_BASE_URL", "http://localhost:8080/BC250")
        self.company_name = company_name or os.getenv("BC_COMPANY_NAME", "")
        self.auth_mode = os.getenv("BC_AUTH", "basic").lower()
        self.username = os.getenv("BC_USERNAME", "")
        self.password = os.getenv("BC_PASSWORD", "")
        self.session = requests.Session()
        self.session.headers.update({"Content-Type": "application/json"})

    def _auth(self):
        if self.auth_mode in ("ntlm", "windows") and HttpNtlmAuth and "\\" in self.username:
            return HttpNtlmAuth(self.username, self.password)  # type: ignore
        return HTTPBasicAuth(self.username, self.password)

    def _api_root(self) -> str:
        return f"{self.base_url}/api"

    def _smart_root(self) -> str:
        return f"{self._api_root()}/SmartTravel/Travel/v1.0"

    def companies(self) -> List[Dict]:
        r = self.session.get(f"{self._smart_root()}/companies", auth=self._auth(), timeout=20)
        r.raise_for_status()
        return r.json().get("value", [])

    def company_id(self) -> Optional[str]:
        if not self.company_name:
            return None
        for c in self.companies():
            if c.get("name", "").lower() == self.company_name.lower():
                return c.get("id")
        return None

    def travel_services(self, company_id: str) -> List[Dict]:
        r = self.session.get(f"{self._smart_root()}/companies({company_id})/travelServices", auth=self._auth(), timeout=20)
        r.raise_for_status()
        return r.json().get("value", [])

    def travel_client(self, company_id: str, client_no: str) -> Optional[Dict]:
        url = f"{self._smart_root()}/companies({company_id})/travelClients?$filter=no eq '{client_no}'"
        r = self.session.get(url, auth=self._auth(), timeout=20)
        r.raise_for_status()
        arr = r.json().get("value", [])
        return arr[0] if arr else None

    def reservations_for_client(self, company_id: str, client_no: str) -> List[Dict]:
        url = f"{self._smart_root()}/companies({company_id})/travelReservations?$filter=clientNo eq '{client_no}'"
        r = self.session.get(url, auth=self._auth(), timeout=20)
        r.raise_for_status()
        return r.json().get("value", [])

