import re

import bcrypt
from sqlalchemy import exists

from app.database import SessionLocal, User
from app.models import SignUpForm, UserData, SignUpResponse


class UserValidator:
    EMAIL_REGEX = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b'

    def __init__(self, data: SignUpForm, session: SessionLocal):
        self.data = data
        self.session = session
        self.errors = {}

    def call(self) -> bool:
        if not re.fullmatch(self.EMAIL_REGEX, str(self.data.email)):
            self.errors['email'] = 'has invalid format'
        if not self.data.username:
            self.errors['username'] = 'must be present'
        if not self.is_password_valid():
            self.errors['password'] = 'must be 8+ symbols, contain both letters and digits'
        if self.data.password != self.data.repeat_password:
            self.errors['repeat_password'] = 'passwords do not match'
        if not self.errors and self.is_user_exist():
            self.errors['email'] = 'already in use'
        return len(self.errors) == 0

    def is_password_valid(self):
        password = self.data.password
        return len(password) >= 8 and not password.isalpha() and not password.isnumeric()

    def is_user_exist(self):
        return self.session.query(
            exists().where(User.email == self.data.email, User.is_active == True)
        ).scalar()


class PasswordEncryptor:
    ENCODING = 'utf-8'

    def __init__(self, password: str):
        self.password = password
        self.encoded_pass = self.password.encode(self.ENCODING)

    def call(self):
        return bcrypt.hashpw(self.encoded_pass, bcrypt.gensalt()).decode(self.ENCODING)


class RegisterUserService:
    def __init__(self, data: SignUpForm):
        self.data = data
        self.session = SessionLocal()
        self.user = None

    def call(self):
        validator = UserValidator(data=self.data, session=self.session)
        if not validator.call():
            return self.service_response(errors=validator.errors)

        self.save_user()
        return self.service_response(errors={})

    def save_user(self):
        encrypted_password = PasswordEncryptor(self.data.password).call()
        user = User(
            email=self.data.email,
            username=self.data.username,
            salty_password=encrypted_password,  # Make sure to hash this in real use!
            is_active=True,
            role=User.Roles.REGULAR.value
        )
        self.session.add(user)
        self.session.commit()
        self.session.refresh(user)
        self.user = UserData.from_db(user)

    def service_response(self, errors):
        return SignUpResponse(user=self.user, errors=errors)
