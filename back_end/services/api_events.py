import requests
from fastapi import APIRouter, HTTPException
from config import TICKETMASTER_API_KEY 

router = APIRouter(prefix="/events", tags=["events"])
TICKETMASTER_API_URL = "https://app.ticketmaster.com/discovery/v2/events"

@router.get("/")
async def get_events(keyword: str, city: str):
    params = {
        "apikey": TICKETMASTER_API_KEY,
        "keyword": keyword,
        "city": city,
        "size": 20
    }
    response = requests.get(TICKETMASTER_API_URL, params=params)
    if response.status_code != 200:
        raise HTTPException(status_code=500, detail="Error fetching events from Ticketmaster")
    data = response.json()
    events = data.get("_embedded", {}).get("events", [])
    formatted = [
        {
            "name": event["name"],
            "id": event["id"],
            "url": event["url"],
            "date": event["dates"]["start"].get("localDate"),
            "priceRanges": event.get("priceRanges", []),        
            "time": event["dates"]["start"].get("localTime"),
            "venue": event["_embedded"]["venues"][0]["name"] if "_embedded" in event and "venues" in event["_embedded"] else "N/A"
        }
        for event in events
    ]
    return {"events": formatted}