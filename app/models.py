from sqlalchemy import Column, Integer, String
from app.database import Base

class VPNUser(Base):
    """Модель пользователя VPN"""
    __tablename__ = "vpn_users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    private_key = Column(String, unique=True, nullable=False)
    public_key = Column(String, unique=True, nullable=False)
    ip_address = Column(String, unique=True, nullable=False)

class User(Base):
    """Модель пользователя"""
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String, nullable=False)