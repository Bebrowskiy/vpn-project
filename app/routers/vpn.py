from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app import crud, schemas, database
from app.dependencies import get_current_user


router = APIRouter()

@router.post("/vpn/create/", response_model=schemas.VPNUserResponse)
def create_vpn_user(user_data: schemas.VPNUserCreate, db: Session = Depends(database.get_db), user=Depends(get_current_user)):
    """Создаёт VPN-пользователя (для авторизованных)"""
    return crud.create_vpn_user(db, user.username)

@router.get("/vpn/{username}/", response_model=schemas.VPNUserResponse)
def get_vpn_user(username: str, db: Session = Depends(database.get_db), user=Depends(get_current_user)):
    """Получает данные о VPN (только для авторизованных)"""
    return crud.get_vpn_user(db, username)