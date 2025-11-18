from config import MAILGUN_API_KEY, MAILGUN_DOMAIN, MAILGUN_FROM
import requests

def send_email(to: str, subject: str, html: str ):
    url = f"https://api.mailgun.net/v3/{MAILGUN_DOMAIN}/messages"

    response = requests.post(
        url,
        auth=("api", MAILGUN_API_KEY),
        data={
            "from":f"Qestora <{MAILGUN_FROM}>",
            "to": to,
            "subject": subject,
            "html": html
        }
    )
    if response.status_code != 200:
        raise Exception(f"Failed to send email: {response.text}")
    return response.status_code

def welcome_email(to: str, name: str):
    subject = "Welcome to Qestora!"
    html = f"""
       <h2>Hello {name},</h2>
       <p>Thank you for registering with Qestora. We're excited to have you on board!</p>
       <p>Best regards,<br/>The Qestora Team</p>"""
    
    return send_email(to, subject, html)

def password_reset_email(to: str, token: str):
    reset_link = f"http://localhost:8000/auth/reset-password?token={token}"
    subject = "Qestora Password Reset"
    html = f"""
       <h2>Password Reset Request</h2>
       <p>Click the link below to reset your password:</p>
       <a href="{reset_link}">Reset Password</a>
       <small> This link will expire in 15 minutes. </small>
       <p>If you did not request a password reset, please ignore this email.</p>
       <p>Best regards,<br/>The Qestora Team</p>"""
    
    return send_email(to, subject, html)

