# utils/commands_utils.py
from aiogram.types import BotCommand

BOT_COMMANDS = [
    BotCommand(command="start", description="Запуск бота"),
    BotCommand(command="help", description="Я не придумал"),
    BotCommand(command="reset_telegram", description= "Зарегестрировать уже существующий VPN-аккаунт на текущий аккаунт телеграм"),
    BotCommand(command="register", description= "Регистрация аккаунта"),
    BotCommand(command="account", description="Выводит информация об аккаунте")
]
