from pydantic import BaseModel
from typing import Optional

# Схема для регистрации нового пользователя
class UserCreate(BaseModel):
    username: str  # Имя пользователя
    email: str  # Электронная почта
    password: str  # Пароль

# Схема для входа пользователя (с токеном)
class UserLogin(BaseModel):
    username: str  # Имя пользователя
    password: str  # Пароль

# Схема для ответа с токеном
class Token(BaseModel):
    access_token: str  # JWT-токен
    token_type: str  # Тип токена (обычно "bearer")

# Схема для отображения информации о пользователе
class User(BaseModel):
    id: int  # Идентификатор пользователя
    username: str  # Имя пользователя
    email: str  # Электронная почта

    class Config:
        orm_mode = True  # Для работы с ORM-моделями, используем эту опцию
