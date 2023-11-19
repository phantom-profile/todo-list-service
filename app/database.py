import datetime
import uuid
from enum import StrEnum

from redis import Redis
from sqlalchemy import (
    create_engine,
    Column,
    ForeignKey, Integer, String, Uuid, DateTime, Float, Boolean,
    UniqueConstraint
)
from sqlalchemy.orm import sessionmaker, relationship, declarative_base

SQLALCHEMY_DATABASE_URL = "sqlite:///activities.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}, echo=True
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
Red = Redis(host='localhost', port=6379, decode_responses=True)


class UserRoles(StrEnum):
    ADMIN = 'admin'
    REGULAR = 'regilar'
    PUBLISHER = 'publisher'


class User(Base):
    __tablename__ = "users"
    Roles = UserRoles

    id = Column(Integer, primary_key=True, index=True, nullable=False)
    username = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, index=True, nullable=False)
    salty_password = Column(String(255), nullable=False)
    role = Column(String(30), nullable=False, default='regular', index=True)
    is_active = Column(Boolean, nullable=False, default=True, index=True)

    @property
    def enum_role(self):
        return self.Roles(self.role)

#
# class Card(Base):
#     __tablename__ = "cards"
#
#     id = Column(Integer, primary_key=True, index=True, nullable=False)
#     card_number = Column(String, unique=True, index=True, nullable=False)
#     cvv = Column(String, index=True, nullable=False)
#     owner = Column(String, nullable=False)
#     payment_system = Column(String, nullable=False)
#     trusted_app_id = Column(Integer, ForeignKey("users.id"), nullable=False)
#     bank_name = Column(String, nullable=False)
#
#     trusted_app = relationship("User", back_populates="cards", foreign_keys=[trusted_app_id])
#     sent_transactions = relationship(
#         "Transaction",
#         back_populates="src",
#         foreign_keys='Transaction.src_card_id'
#     )
#     received_transactions = relationship(
#         "Transaction",
#         back_populates="dst",
#         foreign_keys='Transaction.dst_card_id'
#     )
#
#     __table_args__ = (UniqueConstraint('card_number', 'cvv', name='card_number_cvv_index'),)
#
#
# class Transaction(Base):
#     __tablename__ = "transactions"
#
#     id = Column(Integer, primary_key=True, index=True, nullable=False)
#     src_card_id = Column(Uuid, ForeignKey("cards.id"), index=True, nullable=False)
#     dst_card_id = Column(Uuid, ForeignKey("cards.id"), index=True, nullable=False)
#     created_at = Column(DateTime, default=datetime.datetime.now, nullable=False)
#     status = Column(String, index=True, nullable=False)
#     amount_usd = Column(Float, nullable=False)
#     comission = Column(Float, nullable=False, default=0.0)
#
#     src = relationship("Card", back_populates="sent_transactions", foreign_keys=[src_card_id])
#     dst = relationship("Card", back_populates="received_transactions", foreign_keys=[dst_card_id])
