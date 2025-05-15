import secrets
from typing import Optional
import time
import hashlib
import base64

from app import models
from app.database import get_db

telegram_tokens = {}

def generate_keys(username: str):
    """Генерация фиктивных ключей на основе имени пользователя"""
    private_key = base64.b64encode(hashlib.sha256(username.encode()).digest()).decode()[:44]
    public_key = base64.b64encode(hashlib.sha256(private_key.encode()).digest()).decode()[:44]
    return private_key, public_key

def gen_telegram_token(user_id: int) -> str:
    """
    Генерация уникального токена для привязки Telegram
    """

    token = secrets.token_urlsafe(16) # Random Generation
    expires_at = time.time() + 300 # Token expires in 5 minutes
    telegram_tokens[token] = {
        "user_id": user_id,
        "expires_at": expires_at
    }
    return token

def verify_telegram_token(token: str, db) -> Optional[models.User]:
    """
    Проверка токена для привязки Telegram.
    """
    if token in telegram_tokens:
        data = telegram_tokens[token]
        if data["expires_at"] > time.time():
            # Получаем пользователя по ID
            user = db.query(models.User).filter(models.User.id == data["user_id"]).first()
            if user:
                del telegram_tokens[token]  # Удаляем токен после использования
                return user
    return None