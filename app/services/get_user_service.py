from app.database import Red, User, SessionLocal
from app.models import UserData


class GetUserService:
    def __init__(self, token: str):
        self.token = token
        self.user = None

    def call(self) -> UserData | None:
        user_id = Red.get(f'session-{self.token}')
        if not user_id:
            return None

        self.user = SessionLocal().query(User).filter(User.id == user_id)
        return self.serialized_user()

    def serialized_user(self):
        return UserData(
            username=self.user.username,
            id=self.user.id,
            role=self.user.role,
            is_active=self.user.is_active,
            email=self.user.email
        )
