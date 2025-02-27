from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import timedelta
from app import crud, schemas, database
from app.utils.auth import create_jwt_token
from app.config import ACCESS_TOKEN_EXPIRE_MINUTES

router = APIRouter()

@router.post("/register", response_model=schemas.Token)
def register_user(user_data: schemas.UserCreate, db: Session = Depends(database.get_db)):
    """Регистрация нового пользователя"""
    if crud.get_vpn_user(db, user_data.username):
        raise HTTPException(status_code=400, detail="Пользователь уже существует")
    user = crud.create_user(db, user_data)
    access_token = create_jwt_token(
        data={"sub": user.username},
        expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    return {"access_token": access_token, "token_type": "bearer"}

@router.post("/login", response_model=schemas.Token)
def login_user(user_data: schemas.UserLogin, db: Session = Depends(database.get_db)):
    """Авторизация пользователя"""
    user = crud.authenticate_user(db, user_data.username, user_data.password)
    if not user:
        raise HTTPException(status_code=401, detail="Неправильное имя пользователя или пароль")
    
    access_token = create_jwt_token(
        data={"sub": user.username},
        expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )

    return {"access_token": access_token, "token_type": "bearer"}