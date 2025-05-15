from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "sqlite:///vpn.db"

engine = create_engine(
    DATABASE_URL,
    pool_size=10,  # Размер пула соединений
    max_overflow=20,  # Максимальное количество дополнительных соединений
    pool_timeout=30,  # Таймаут ожидания соединения
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    """Функция для получения сессии базы данных"""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
