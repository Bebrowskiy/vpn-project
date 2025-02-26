from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session
from . import crud, models, schemas, security, dependencies
from .database import engine
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm

app = FastAPI()

# Создаем таблицы в базе данных, если они еще не существуют
models.Base.metadata.create_all(bind=engine)

# OAuth2 схема для получения токена
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# Регистрация нового пользователя
@app.post("/register/", response_model=schemas.User)
def register(user: schemas.UserCreate, db: Session = Depends(dependencies.get_db)):
    return crud.create_user(db=db, user=user)  # Вызываем функцию создания пользователя

# Логин и получение JWT-токена
@app.post("/token/", response_model=schemas.Token)
def login_for_access_token(form_data: schemas.UserLogin, db: Session = Depends(dependencies.get_db)):
    user = crud.authenticate_user(db=db, username=form_data.username, password=form_data.password)  # Проверяем пользователя
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid credentials",  # Неверные учетные данные
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token = security.create_access_token(data={"sub": user.username})  # Создаем токен
    return {"access_token": access_token, "token_type": "bearer"}

# Пример защищенного маршрута, доступного только с действительным токеном
@app.get("/users/me", response_model=schemas.User)
def read_users_me(current_user: models.User = Depends(dependencies.get_current_user)):  # Получаем текущего пользователя
    return current_user  # Возвращаем информацию о текущем пользователе

@app.get("/user/{username}", response_model=schemas.User)
def read_user(username: str, db: Session = Depends(dependencies.get_db)):
    db_user = crud.get_user_by_username(db=db, username=username)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user
