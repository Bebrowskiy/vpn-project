from sqlalchemy.orm import Session
from fastapi import Depends, HTTPException
from .database import SessionLocal
from . import crud, models, security
from .auth import oauth2_scheme  # Импортируем oauth2_scheme из main.py

# Получение базы данных через зависимость
def get_db():
    db = SessionLocal()  # Создаем объект сессии базы данных
    try:
        yield db
    finally:
        db.close()  # Закрываем сессию после использования

# Проверка текущего пользователя по токену
def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    payload = security.verify_token(token)  # Проверяем токен
    if payload is None:
        raise credentials_exception  # Если токен недействителен, выбрасываем ошибку
    username: str = payload.get("sub")  # Получаем имя пользователя из токена
    if username is None:
        raise credentials_exception  # Если в токене нет имени пользователя, выбрасываем ошибку
    user = crud.get_user_by_username(db, username=username)  # Получаем пользователя из базы данных
    if user is None:
        raise credentials_exception  # Если пользователь не найден, выбрасываем ошибку
    return user  # Возвращаем текущего пользователя
