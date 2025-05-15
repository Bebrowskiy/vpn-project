from pydantic import BaseModel
from typing import Optional

class UserCreate(BaseModel):
    """Модель для создания пользователя"""
    username: str
    email: str
    password: str

class UserLogin(BaseModel):
    """Модель для входа пользователя"""
    username: str
    password: str

class Token(BaseModel):
    """Модель для токена"""
    access_token: str
    token_type: str

class UserResponse(BaseModel):
    """Модель для возврата данных пользователя"""
    username: str
    email: str
    telegram_id: Optional[int] = None

    class Config:
        orm_mode = True

class VPNUserResponse(BaseModel):
    """Модель для возврата данных VPN-пользователя"""
    username: str
    private_key: str
    public_key: str
    ip_address: str
    telegram_id: Optional[int] = None
    message: str = "VPN пользователь создан успешно"

    class Config:
        orm_mode = True

class UserUpdate(BaseModel):
    """Модель для обновления данных пользователя"""
    email: Optional[str] = None
    password: Optional[str] = None

class LinkTelegram(BaseModel):
    """Модель для привязки Telegram ID"""
    token: str
    telegram_id: int

class CreateVPNUser(BaseModel):
    """Модель для создания VPN-пользователя"""
    username: str