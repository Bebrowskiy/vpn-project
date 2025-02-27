from sqlalchemy.orm import Session
from app import models, schemas
from app.utils.keygen import generate_keys
from app.utils.auth import hash_password, verify_password

def create_vpn_user(db: Session, username: str):
    """Создаёт нового пользователя VPN"""
    private_key, public_key = generate_keys(username)
    ip_address = f"10.0.0.{100 + hash(username) % 100}/32"

    user = models.VPNUser(
        username=username,
        private_key=private_key,
        public_key=public_key,
        ip_address=ip_address
    )
    
    db.add(user)
    db.commit()
    db.refresh(user)
    return user

def get_vpn_user(db: Session, username: str):
    """Получает пользователя VPN по имени"""
    return db.query(models.VPNUser).filter(models.VPNUser.username == username).first()

def create_user(db: Session, user: schemas.UserCreate):
    """Создаёт нового пользователя"""
    hashed_password = hash_password(user.password)
    db_user = models.User(username=user.username, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def authenticate_user(db: Session, username: str, password: str):
    """Аутентифицирует пользователя"""
    user = db.query(models.User).filter(models.User.username == username).first()
    if not user or not verify_password(password, user.hashed_password):
        return None
    return user