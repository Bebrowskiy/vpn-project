from sqlalchemy.orm import Session
from app import models, schemas
from app.utils.keygen import generate_keys
from app.utils.auth import verify_password
from uuid import uuid4

def create_user(db: Session, user: schemas.UserCreate):
    """Создаёт нового пользователя."""
    db_user = models.User(
        username=user.username,
        email=user.email,
        hashed_password=user.password
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def get_user_by_username(db: Session, username: str):
    """Получает пользователя по имени."""
    return db.query(models.User).filter(models.User.username == username).first()

def get_user_by_email(db: Session, email: str):
    """Получает пользователя по email."""
    return db.query(models.User).filter(models.User.email == email).first()

def authenticate_user(db: Session, username: str, password: str):
    """Аутентифицирует пользователя."""
    user = get_user_by_username(db, username)
    if not user or not verify_password(password, user.hashed_password):
        return None
    return user

def create_vpn_user(db: Session, username: str, telegram_id: int = None):
    """Создаёт нового пользователя VPN."""
    private_key, public_key = generate_keys(username)
    ip_address = f"10.0.0.{uuid4().int % 256}/32"

    user = models.VPNUser(
        username=username,
        private_key=private_key,
        public_key=public_key,
        ip_address=ip_address,
        telegram_id=telegram_id
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return {**user.__dict__, "message": "VPN пользователь создан успешно"}

def get_vpn_user(db: Session, username: str):
    """Получает пользователя VPN по имени."""
    return db.query(models.VPNUser).filter(models.VPNUser.username == username).first()

def set_vpn_telegram_id(db: Session, username: str, telegram_id: int):
    """Устанавливает Telegram ID пользователя VPN."""
    user = db.query(models.VPNUser).filter(models.VPNUser.username == username).first()
    if not user:
        return None
    user.telegram_id = telegram_id
    db.commit()
    db.refresh(user)
    return user