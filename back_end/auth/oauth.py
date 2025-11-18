from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from google.oauth2 import id_token
from google.auth.transport import requests

from models.database import get_db
from models.user import User
from auth.jwt_handler import create_access_token
from models.schemas import UserLoggedIn, TokenData
from pydantic import BaseModel

from config import GOOGLE_CLIENT_ID

router = APIRouter(prefix="/auth", tags=["Google Authentication"])

class GoogleLogin(BaseModel):
    idToken: str

@router.post("/google")
async def login_with_google(data: GoogleLogin, db: Session = Depends(get_db)):
    try:
      
        info = id_token.verify_oauth2_token(
            data.idToken,
            requests.Request(),
            GOOGLE_CLIENT_ID
        )
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid Google token")

    email = info.get("email")
    name = info.get("name")
    google_id = info.get("sub")

    if email is None:
        raise HTTPException(status_code=400, detail="Google email not found")


    user = db.query(User).filter(User.email == email).first()

    if not user:
   
        user = User(
            full_name=name,
            email=email,
            provider="google",
            provider_id=google_id,
            password=None
        )
        db.add(user)
        db.commit()
        db.refresh(user)

   
    jwt_token = create_access_token({"sub": user.email})

    return {
        "access_token": jwt_token,
        "user": {
            "email": user.email,
            "full_name": user.full_name
        }
    }
