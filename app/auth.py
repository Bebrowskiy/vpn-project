from fastapi.security import OAuth2PasswordBearer

# OAuth2 схема для получения токена
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
