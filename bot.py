from telegram import Update
from telegram.ext import ApplicationBuilder, CommandHandler, MessageHandler, filters, ContextTypes
import requests

# URL вашего сервера
SERVER_URL = "http://192.168.0.54:8000/api"

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text("Привет! Отправьте мне токен из приложения.")

async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    token = update.message.text.strip()
    telegram_id = update.effective_user.id

    # Отправляем запрос на сервер
    response = requests.post(
        f"{SERVER_URL}/link-telegram-bot",
        json={"token": token, "telegram_id": telegram_id}
    )

    if response.status_code == 200:
        await update.message.reply_text("Telegram успешно привязан!")
    else:
        await update.message.reply_text("Ошибка: неверный токен или он истек.")

def main():
    # Замените YOUR_BOT_TOKEN на ваш токен
    application = ApplicationBuilder().token("6314702268:AAEBRk0S0larwJyb3ILXuP3FGZJll36s9wk").build()

    # Регистрируем обработчики
    application.add_handler(CommandHandler("start", start))
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))

    # Запускаем бота
    application.run_polling()

if __name__ == "__main__":
    main()