import requests
from requests.auth import HTTPBasicAuth

# --- CONFIGURATION ---
BASE_URL = "http://yosra-ghanmi:7048/BC250/ODataV4/Company('smart%20travel%20agency')/TravelServiceAPI"

USERNAME = r"YOSRA-GHANMI\yosra" 

AUTH_KEY = "ezRFNTJCMzhDLTQ3QzUtNDk4NC04NUFFLTg3MkI1M0MxMjZBRn0="

def test_connection():
    print(f"Testing connection to: {BASE_URL}")
    print(f"User: {USERNAME}")
    
    try:
        # Houni n-connectiou direct bel AUTH_KEY
        response = requests.get(
            BASE_URL,
            auth=HTTPBasicAuth(USERNAME, AUTH_KEY),
            headers={"Content-Type": "application/json"},
            timeout=10
        )
        
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            print("✅ Success! Connection established.")
            data = response.json()
            items = data.get('value', [])
            print(f"Found {len(items)} items.")
            if items:
                print("First item sample:")
                print(items[0])
        elif response.status_code == 401:
            print("❌ Authentication failed. Check your Username or Key.")
        else:
            print(f"❌ Error: {response.text}")
            
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    test_connection()