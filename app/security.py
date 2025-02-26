from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext

# Секретный ключ для подписи JWT. Он должен быть уникальным и храниться в безопасном месте.
SECRET_KEY = "7bba72f87fc01d24ee5f1536a8bb8d81b45ec8fd1b70327e93c19aeacb282428"
ALGORITHM = "HS256"  # Алгоритм для подписи JWT
ACCESS_TOKEN_EXPIRE_MINUTES = 30  # Время истечения срока действия токена

# Контекст для хэширования паролей с использованием алгоритма bcrypt
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Функция для хэширования пароля
def hash_password(password: str):
    return pwd_context.hash(password)

# Функция для проверки пароля
def verify_password(plain_password: str, hashed_password: str):
    return pwd_context.verify(plain_password, hashed_password)

# Функция для создания JWT-токена
def create_access_token(data: dict, expires_delta: timedelta = timedelta(minutes=15)):
    to_encode = data.copy()
    expire = datetime.utcnow() + expires_delta  # Устанавливаем время истечения токена
    to_encode.update({"exp": expire})  # Добавляем информацию о времени истечения
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)  # Создаем и кодируем JWT
    return encoded_jwt

# Функция для проверки токена
def verify_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])  # Декодируем JWT
        return payload
    except JWTError:
        return None  # Если токен недействителен, возвращаем None
