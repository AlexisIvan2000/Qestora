from fastapi import APIRouter, Depends, HTTPException, Request
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session
import requests
from models.database import get_db
from models.user import User
from auth.jwt_handler import create_access_token
from config import (
    GOOGLE_CLIENT_ID,
    GOOGLE_CLIENT_SECRET,
    GOOGLE_REDIRECT_URI
)

oauth_router = APIRouter(
    prefix="/oauth",
    tags=["Google OAuth"]
)

GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth"
GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token"
GOOGLE_USERINFO_URL = "https://www.googleapis.com/oauth2/v3/userinfo"


# ---------------------------------------------------------
# 1. Redirection vers Google
# ---------------------------------------------------------

@oauth_router.get("/login/google")
def google_login():
    auth_url = (
        f"{GOOGLE_AUTH_URL}"
        "?response_type=code"
        f"&client_id={GOOGLE_CLIENT_ID}"
        f"&redirect_uri={GOOGLE_REDIRECT_URI}"
        "&scope=openid%20email%20profile"
        "&access_type=offline"
        "&prompt=consent"
    )
    return RedirectResponse(url=auth_url)


# ---------------------------------------------------------
# 2. Callback Google (route très importante)
# ---------------------------------------------------------

@oauth_router.get("/google/callback")
def google_callback(request: Request, db: Session = Depends(get_db)):

    # 1. Extraction du code Google
    code = request.query_params.get("code")
    if not code:
        raise HTTPException(400, "No Google authentication code provided")

    # 2. Exchange code -> access token
    token_payload = {
        "code": code,
        "client_id": GOOGLE_CLIENT_ID,
        "client_secret": GOOGLE_CLIENT_SECRET,
        "redirect_uri": GOOGLE_REDIRECT_URI,
        "grant_type": "authorization_code",
    }

    token_response = requests.post(GOOGLE_TOKEN_URL, data=token_payload)
    token_json = token_response.json()

    if "error" in token_json:
        raise HTTPException(400, f"Google token exchange failed: {token_json}")

    access_token = token_json.get("access_token")
    refresh_token = token_json.get("refresh_token")

    if not access_token:
        raise HTTPException(400, "Google did not return an access token")

    # 3. Retrieve Google account info
    user_info_response = requests.get(
        GOOGLE_USERINFO_URL,
        headers={"Authorization": f"Bearer {access_token}"}
    )

    google_user = user_info_response.json()

    if "sub" not in google_user:
        raise HTTPException(400, "Invalid Google user info")

    google_id = google_user["sub"]
    email = google_user["email"]
    name = google_user.get("name", "Unnamed User")

    # 4. Check if user already exists
    user = (
        db.query(User)
        .filter(User.provider == "google", User.provider_id == google_id)
        .first()
    )

    # Create account if new Google user
    if not user:
        user = User(
            full_name=name,
            email=email,
            provider="google",
            provider_id=google_id,
            oauth_token=access_token,
        )
        db.add(user)
        db.commit()
        db.refresh(user)

    # 5. Creation du JWT
    jwt_token = create_access_token({"user_id": user.id})

    # 6. Redirection vers ton frontend
    # Mets l’URL de ton APP Flutter Web / Mobile
    # redirect_url = f"http://localhost:3000/oauth/success?token={jwt_token}"

    # return RedirectResponse(url=redirect_url)
    return {
        "message": "Google OAuth success",
        "user": {
            "id": user.id,
            "name": user.full_name,
            "email": user.email,
        },
        "jwt_token": jwt_token,
        "google_access_token": access_token,
        "google_refresh_token": refresh_token,
    }