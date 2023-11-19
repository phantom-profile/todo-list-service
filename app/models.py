from uuid import UUID, uuid4

from dotenv import dotenv_values
from pydantic import BaseModel, Field

from app import database
from app.database import UserRoles

env_variables = dotenv_values(".env")


class MainInfo(BaseModel):
    created_by: str = env_variables['AUTHOR']
    doc_url: str = env_variables['DOCS_URL']
    description: str = env_variables['DESCRIPTION']

class TokenParam(BaseModel):
    token: UUID = Field(examples=[uuid4()])


class UserData(BaseModel):
    id: int = Field(examples=[1], frozen=True)
    email: str = Field(max_length=100, examples=['user@gmail.com'])
    username: str = Field(max_length=100, examples=['cooluser'])
    role: UserRoles = Field(frozen=True, examples=[UserRoles.REGULAR, UserRoles.PUBLISHER])
    is_active: bool = Field(frozen=True, examples=[True])

    @classmethod
    def from_db(cls, user: database.User):
        return UserData(
            id=user.id,
            email=user.email,
            username=user.username,
            role=user.enum_role,
            is_active=user.is_active
        )


class User(UserData):
    salty_password: str


class SignUpForm(BaseModel):
    email: str = Field(max_length=100, examples=['user@gmail.com'])
    username: str = Field(max_length=100, examples=['cooluser'])
    password: str = Field(max_length=100, examples=['mypass123'])
    repeat_password: str = Field(max_length=100, examples=['mypass123'])


class SignUpResponse(BaseModel):
    user: UserData | None
    errors: dict[str, str]
