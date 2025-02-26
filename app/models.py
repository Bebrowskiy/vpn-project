from sqlalchemy import Column, Integer, String
from .database import Base
from .security import hash_password, verify_password

class User(Base):
    __tablename__ = "users"  # Название таблицы в базе данных

    id = Column(Integer, primary_key=True, index=True)  # Уникальный идентификатор пользователя
    username = Column(String, unique=True, index=True)  # Имя пользователя (уникальное)
    email = Column(String, unique=True, index=True)  # Электронная почта пользователя (уникальная)
    hashed_password = Column(String)  # Хэшированный пароль

    def __repr__(self):
        return f"<User {self.username}>"  # Представление объекта пользователя

    # Метод для установки пароля (хэширует пароль перед сохранением)
    def set_password(self, password: str):
        self.hashed_password = hash_password(password)

    # Метод для проверки пароля
    def check_password(self, password: str):
        return verify_password(password, self.hashed_password)
