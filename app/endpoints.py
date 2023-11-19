from typing import Annotated

from fastapi import FastAPI, status, Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer

from app.database import SessionLocal
from app.models import MainInfo, SignUpForm, SignUpResponse, UserData

from app.services.get_user_service import GetUserService
from app.services.register_user_service import RegisterUserService

app = FastAPI()
db = SessionLocal()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")


def get_current_user(token: Annotated[str, Depends(oauth2_scheme)]):
    return GetUserService(token).call()


@app.get("/")
def root() -> MainInfo:
    return MainInfo()


@app.get("/users/me")
def get(user: Annotated[UserData, Depends(get_current_user)]) -> UserData:
    return user


@app.post("/sign_up")
def register(data: SignUpForm) -> SignUpResponse:
    return RegisterUserService(data=data).call()


# @app.post("/login")
# def login(data: ()):
#     return 1
#
#
# @app.delete("/logout")
# def logout():
#     return 1
