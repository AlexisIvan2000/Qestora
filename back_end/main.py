from fastapi import FastAPI
from auth.user_auth import auth_router
from auth.oauth import  router as google_oauth_router
from models.database import Base, engine
from fastapi.middleware.cors import CORSMiddleware
from reset_password.routes import router as reset_router
from services.api_events import router as events_router

Base.metadata.create_all(bind=engine)
app = FastAPI()
app.include_router(auth_router)
app.include_router(google_oauth_router)
app.include_router(reset_router)
app.include_router(events_router)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],   
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    return {"message": "Welcome to the Authentication API"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)