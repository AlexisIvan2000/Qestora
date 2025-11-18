from pydantic import BaseModel,EmailStr

class UserCreate(BaseModel):
    full_name:str
    email:EmailStr
    password:str


class UserLogin(BaseModel):
    email: EmailStr
    password:str


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


class UserLoggedIn(BaseModel):
    email: str
    full_name: str


class TokenData(Token):
    user: UserLoggedIn

