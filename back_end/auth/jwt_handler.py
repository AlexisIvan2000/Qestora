from datetime import datetime, timedelta
from jose import jwt, JWTError
from config import SECRET_KEY, ALGORITHM

JWT_SECRET_KEY = SECRET_KEY
algorithm = ALGORITHM
ACCESS_TOKEN_EXPIRE_MINUTES = 30

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire, "iat": datetime.utcnow()})
    encoded_jwt = jwt.encode(to_encode, JWT_SECRET_KEY, algorithm=algorithm)
    return encoded_jwt


def verify_access_token(token: str):
    try:
        payload = jwt.decode(token, JWT_SECRET_KEY, algorithms=[algorithm])
        return payload
    except JWTError:
        return None



def create_reset_token(user_id: int):
 
    expire = datetime.utcnow() + timedelta(minutes=15)
    payload = {
        "sub": str(user_id),    
        "exp": expire,
        "iat": datetime.utcnow()
    }
    reset_token = jwt.encode(payload, JWT_SECRET_KEY, algorithm=algorithm)
    return reset_token


def verify_reset_token(token: str):
 
    try:
        payload = jwt.decode(token, JWT_SECRET_KEY, algorithms=[algorithm])
        user_id = payload.get("sub")

        if user_id is None:
            return None
        
        return int(user_id)

    except JWTError:
        return None
