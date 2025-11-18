from fastapi import APIRouter, Request, Form, Depends
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from models.database import get_db
from models.user import User
from auth.user_auth import verify_reset_token, hash_password

router = APIRouter()
templates = Jinja2Templates(directory="reset_password")


@router.get("/auth/reset-password", response_class=HTMLResponse)
async def reset_password_form(request: Request, token: str, db: Session = Depends(get_db)):

    user_id = verify_reset_token(token)
    if not user_id:
        return templates.TemplateResponse("reset_form.html", {
            "request": request,
            "message": "Invalid or expired token",
            "message_type": "error"
        })

    return templates.TemplateResponse("reset_form.html", {
        "request": request,
        "message": None
    })


@router.post("/auth/reset-password", response_class=HTMLResponse)
async def reset_password_submit(
    request: Request,
    token: str,   
    password: str = Form(...),
    confirm: str = Form(...),
    db: Session = Depends(get_db)
):

    user_id = verify_reset_token(token)
    if not user_id:
        return templates.TemplateResponse("reset_form.html", {
            "request": request,
            "message": "Invalid or expired link",
            "message_type": "error"
        })

    if password != confirm:
        return templates.TemplateResponse("reset_form.html", {
            "request": request,
            "message": "Passwords do not match",
            "message_type": "error"
        })

    user = db.query(User).filter(User.id == user_id).first()

    if not user:
        return templates.TemplateResponse("reset_form.html", {
            "request": request,
            "message": "User not found",
            "message_type": "error"
        })

    user.password = hash_password(password)
    db.commit()

    return templates.TemplateResponse("reset_form.html", {
        "request": request,
        "message": "Password reset successfully!",
        "message_type": "success"
    })
