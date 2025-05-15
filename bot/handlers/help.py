# handlers/help.py
from aiogram import Router
from aiogram.filters import Command
from aiogram.types import Message

router = Router()

@router.message(Command("help"))
async def help_handler(message: Message):
    await message.answer("Здесь будут команды...")
    