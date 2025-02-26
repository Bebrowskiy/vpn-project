from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# Указываем URL для подключения к базе данных, например, для SQLite
DATABASE_URL = "sqlite:///./test.db"  # Здесь можно использовать другую БД, если нужно

# Инициализация объекта engine
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})  # Для SQLite

# Создание базового класса для моделей
Base = declarative_base()

# Создание сессии
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
