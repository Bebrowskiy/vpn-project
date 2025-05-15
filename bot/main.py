import asyncio
import logging

from aiogram import Bot, Dispatcher
from aiogram.types import Message
from aiogram.filters import Command

from config import BOT_TOKEN
from handlers import start, help, auth
from utils.commands_utils import BOT_COMMANDS

# Настройка логирования
logging.basicConfig(level=logging.INFO)

# Создаем бота и деспетчер
bot = Bot(token=BOT_TOKEN)
dp = Dispatcher()

# Получаем роутеры команд
dp.include_router(start.router)
dp.include_router(help.router)
dp.include_router(auth.router)

# Установка команд
async def set_my_commands(bot: Bot):
    await bot.set_my_commands(BOT_COMMANDS)

# Запускаем бота
async def main():
    await bot.delete_webhook(drop_pending_updates=True)
    await set_my_commands(bot)
    await dp.start_polling(bot)

if __name__ == "__main__":
    asyncio.run(main())
