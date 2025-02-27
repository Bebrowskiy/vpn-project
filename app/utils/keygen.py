import hashlib
import base64

def generate_keys(username: str):
    """Генерация фиктивных ключей на основе имени пользователя"""
    private_key = base64.b64encode(hashlib.sha256(username.encode()).digest()).decode()[:44]
    public_key = base64.b64encode(hashlib.sha256(private_key.encode()).digest()).decode()[:44]
    return private_key, public_key
