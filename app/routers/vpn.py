from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app import crud, schemas, database, models
from app.dependencies import get_current_user
from app.database import get_db
from app.utils.auth import verify_token

router = APIRouter()

@router.post("/create-vpn-account", response_model=schemas.VPNUserResponse)
async def create_vpn_account(
    data: schemas.CreateVPNUser,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(verify_token)
):
    """
    Создание VPN-аккаунта для пользователя.
    """
    user = db.query(models.User).filter(models.User.id == current_user.id).first()
    if not user or not user.telegram_id:
        raise HTTPException(status_code=400, detail="Telegram ID не привязан")

    # Проверка, существует ли уже VPN-пользователь
    vpn_user = db.query(models.VPNUser).filter(models.VPNUser.username == user.username).first()
    if vpn_user:
        raise HTTPException(status_code=400, detail="VPN-аккаунт уже создан")

    # Генерация ключей и IP-адреса (заглушка)
    private_key = "private_key_example"
    public_key = "public_key_example"
    ip_address = "192.168.1.100"

    # Создание VPN-пользователя
    new_vpn_user = models.VPNUser(
        username=user.username,
        private_key=private_key,
        public_key=public_key,
        ip_address=ip_address,
        telegram_id=user.telegram_id,
    )
    db.add(new_vpn_user)
    db.commit()
    db.refresh(new_vpn_user)

    return schemas.VPNUserResponse(
        username=new_vpn_user.username,
        private_key=new_vpn_user.private_key,
        public_key=new_vpn_user.public_key,
        ip_address=new_vpn_user.ip_address,
        telegram_id=new_vpn_user.telegram_id,
    )

@router.get("/vpn/{username}/", response_model=schemas.VPNUserResponse)
def get_vpn_user(username: str, db: Session = Depends(database.get_db), current_user: models.User = Depends(get_current_user)):
    """
    Получает данные о VPN-пользователе.
    """
    vpn_user = crud.get_vpn_user(db, username)
    if not vpn_user:
        raise HTTPException(status_code=404, detail="VPN пользователь не найден")
    return vpn_user
