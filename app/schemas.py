from pydantic import BaseModel

class VPNUserCreate(BaseModel):
    username: str

class VPNUserResponse(BaseModel):
    username: str
    private_key: str
    public_key: str
    ip_address: str

    class Config:
        orm_mode = True

class UserCreate(BaseModel):
    username: str
    password: str

class UserLogin(BaseModel):
    username: str
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str
