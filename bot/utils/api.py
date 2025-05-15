import aiohttp
import requests
import asyncio

API_URL = "http://127.0.0.1:8000"

def get_token(key: str):

    # Проверка введенного ключа
    if ":" not in key:
        return None, None
    
    # Извлекаем данные из ключа
    username, token = key.split(":", 1)
    username = username.strip()
    token = token.strip()

    return username, token


async def check_telegram_user(telegram_id: int):

    url = f"{API_URL}/api/vpn/telegram/{telegram_id}"
    response = requests.get(url)

    if response.status_code == 200:
        print(response.json())
        return response.json()
    else:
        return False


async def set_telegram_to_vpn(username, telegram_id, token):
    url = f"{API_URL}/api/vpn/{username}/set-telegram/?telegram_id={telegram_id}"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    response = requests.put(url, headers=headers)

    if response.status_code == 200:
        return 200, response.json()
    elif response.status_code == 404:
        return 404, "Аккаунт не найден"
    else:
        return response.status_code, f"Ошибка: {response.text}"


async def create_vpn_user(token, username, telegram_id):

    url = f"{API_URL}/api/vpn/create/"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    params = {
        "username": username,
        "telegram_id": telegram_id
    }

    response = requests.post(url, headers=headers, json=params)

    if response.status_code == 200:
        return 200, response.json()

    elif response.status_code == 400:
        return 400, response.json()

    else:
        # Возвращаем ошибку с кодом статуса, если ответ не 200 и не 404
        return response.status_code, f"Ошибка: {response.text}"

# asyncio.run(create_vpn_user(token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJxcSIsImV4cCI6MTc0MDk5MTM4OH0.D3YELQSs8qyXGZdModvuAHDFvUcgl4w6GpRjP6Gu9cc", username="qq", telegram_id=1234))
# asyncio.run(check_telegram_user(1234))
# asyncio.run(set_telegram_to_vpn(username="qq", telegram_id=123, token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJxcSIsImV4cCI6MTc0MDk5MTM4OH0.D3YELQSs8qyXGZdModvuAHDFvUcgl4w6GpRjP6Gu9cc"))