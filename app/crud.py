from sqlalchemy.orm import Session
from . import models, schemas, security

# Функция для создания нового пользователя
def create_user(db: Session, user: schemas.UserCreate):
    db_user = models.User(username=user.username, email=user.email)
    db_user.set_password(user.password)  # Сохраняем хэшированный пароль
    db.add(db_user)  # Добавляем пользователя в сессию
    db.commit()  # Подтверждаем изменения в базе данных
    db.refresh(db_user)  # Обновляем информацию о пользователе
    return db_user  # Возвращаем объект пользователя

# Функция для получения пользователя по имени пользователя
def get_user_by_username(db: Session, username: str):
    return db.query(models.User).filter(models.User.username == username).first()

# Функция для аутентификации пользователя (проверка имени и пароля)
def authenticate_user(db: Session, username: str, password: str):
    user = get_user_by_username(db, username)  # Получаем пользователя по имени
    if user and user.check_password(password):  # Проверяем пароль
        return user  # Если пользователь найден и пароль правильный, возвращаем пользователя
    return None  # Если аутентификация не удалась, возвращаем None
