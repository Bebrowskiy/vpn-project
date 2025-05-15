from fastapi import FastAPI
from app.database import Base, engine
from app.routers import auth, vpn

# Создание таблиц в БД
Base.metadata.create_all(bind=engine)

app = FastAPI(title="VPN API")

# Подключение роутеров
app.include_router(auth.router, prefix="/api", tags=["Auth"])
app.include_router(vpn.router, prefix="/api", tags=["VPN"])