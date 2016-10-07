from sqlalchemy import Column, Integer, String, Boolean

from talcookie import db

class User(db.Model):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True)
    client_id = Column(String(), nullable=False, unique=True)
    device_token = Column(String(100), unique=True)
    ios = Column(Boolean)

    def __init__(self, client_id, device_token=None, ios=None):
        self.client_id = client_id
        self.device_token = device_token
        self.ios = ios
