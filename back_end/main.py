from fastapi import FastAPI
from auth.user_auth import auth_router
from models.database import Base, engine

Base.metadata.create_all(bind=engine)
app = FastAPI()
app.include_router(auth_router)

@app.get("/")
async def root():
    return {"message": "Welcome to the Authentication API"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)