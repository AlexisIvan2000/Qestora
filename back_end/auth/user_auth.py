from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from passlib.context import CryptContext
from services.email import welcome_email, password_reset_email

from models.database import get_db
from models.user import User
from models.schemas import UserLogin, Token, TokenData, UserLoggedIn, UserCreate
from auth.jwt_handler import create_access_token, verify_access_token,verify_reset_token, create_reset_token

pwd_context = CryptContext(schemes=["argon2"], deprecated="auto")

auth_router = APIRouter(
    prefix="/auth",
    tags=["Authentication"]
)
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

@auth_router.post("/register", status_code=status.HTTP_201_CREATED)
async def register_user(user: UserCreate, db: Session = Depends(get_db)):
    exists = db.query(User).filter(User.email == user.email).first()
    if exists:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email already registered")
    
    hashed_password = hash_password(user.password)
    new_user = User(
        full_name=user.full_name,
        email=user.email,
        password=hashed_password
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    welcome_email(new_user.email, new_user.full_name)
    return {"msg": "User registered successfully"}

@auth_router.post("/login", response_model=TokenData)
async def login(user_credentials: UserLogin, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == user_credentials.email).first()
    if not user or not verify_password(user_credentials.password, user.password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")
    
    access_token = create_access_token(data={"sub": user.email})
    token_data = TokenData(
        access_token=access_token,
        user=UserLoggedIn(email=user.email, full_name=user.full_name)
    )
    return token_data

@auth_router.post("/forgot-password")
async def forgot_password(email: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == email).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Email not found")
    
    reset_token = create_reset_token(email)
    password_reset_email(email, reset_token)
    return {"msg": "Password reset email sent"}

@auth_router.post("/reset-password")
async def reset_password(token: str, new_password: str, db: Session = Depends(get_db)):

    email = verify_reset_token(token)
    if not email:
        raise HTTPException(400, "Invalid or expired token")

    user = db.query(User).filter(User.email == email).first()
    if not user:
        raise HTTPException(404, "User not found")

    hashed_password = hash_password(new_password)
    user.password = hashed_password
    db.commit()

    return {"message": "Password successfully reset"}

@auth_router.get("/me")
async def get_current_user(token: str):
    payload = verify_access_token(token)
    if not payload:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")
    return {"email": payload.get("sub")} 