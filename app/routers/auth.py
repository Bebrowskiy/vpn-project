from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import timedelta
from app import crud, schemas, database, models
from app.utils.auth import create_jwt_token, hash_password, verify_password, verify_token
from app.dependencies import get_current_user
from app.database import get_db
from app.utils.keygen import gen_telegram_token, verify_telegram_token
from app.config import ACCESS_TOKEN_EXPIRE_MINUTES
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

router = APIRouter()

@router.post("/register", response_model=schemas.Token)
def register_user(user_data: schemas.UserCreate, db: Session = Depends(database.get_db)):
    """
    Регистрация нового пользователя.
    """
    logger.info(f"Registering user: {user_data.username}")
    if crud.get_user_by_username(db, user_data.username):
        raise HTTPException(status_code=400, detail="Пользователь с таким именем уже существует")
    
    if crud.get_user_by_email(db, user_data.email):
        raise HTTPException(status_code=400, detail="Пользователь с таким email уже существует")
    
    hashed_password = hash_password(user_data.password)
    user_data.password = hashed_password
    user = crud.create_user(db, user_data)

    access_token = create_jwt_token(
        data={"sub": user.username},
        expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    return {"access_token": access_token, "token_type": "bearer"}

@router.post("/login", response_model=schemas.Token)
def login_user(user_data: schemas.UserLogin, db: Session = Depends(database.get_db)):
    """
    Авторизация пользователя.
    """
    user = crud.authenticate_user(db, user_data.username, user_data.password)
    if not user:
        raise HTTPException(status_code=401, detail="Неправильное имя пользователя или пароль")
    
    access_token = create_jwt_token(
        data={"sub": user.username},
        expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    return {"access_token": access_token, "token_type": "bearer"}

@router.get("/profile", response_model=schemas.UserResponse)
def get_profile(current_user: models.User = Depends(get_current_user)):
    """
    Возвращает данные текущего пользователя.
    """
    return schemas.UserResponse(
        username=current_user.username,
        email=current_user.email,
        telegram_id=current_user.telegram_id
    )

@router.put("/profile/update", response_model=schemas.UserResponse)
def update_profile(
    update_data: schemas.UserUpdate,
    current_user: models.User = Depends(get_current_user),
    db: Session = Depends(database.get_db)
):
    """
    Обновляет данные текущего пользователя.
    """
    if update_data.password:
        current_user.hashed_password = hash_password(update_data.password)
    if update_data.email:
        current_user.email = update_data.email
    
    db.commit()
    db.refresh(current_user)
    return {
        "username": current_user.username,
        "email": current_user.email
    }

@router.post("/link-telegram-bot", response_model=schemas.UserResponse)
async def link_telegram_bot(
    data: schemas.LinkTelegram,
    db: Session = Depends(get_db),
):
    """
    Привязка Telegram ID к пользователю через бота.
    """
    user = verify_telegram_token(data.token, db)
    if not user:
        raise HTTPException(status_code=400, detail="Invalid token")

    # Проверяем, что Telegram ID не занят другим пользователем
    existing_user = db.query(models.User).filter(models.User.telegram_id == data.telegram_id).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="This Telegram ID is already linked to another account")

    # Привязываем Telegram ID
    user.telegram_id = data.telegram_id
    db.commit()
    db.refresh(user)

    return schemas.UserResponse(username=user.username, email=user.email)

@router.post("/generate-telegram-token", response_model=schemas.Token)
async def generate_telegram_token(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(verify_token)
):
    """
    Генерирует токен для Telegram.
    """
    
    token = gen_telegram_token(current_user.id)
    return {"access_token": token, "token_type": "telegram"}
    