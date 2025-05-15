# handlers/auth.py
from aiogram import Router
from aiogram.filters import Command
from aiogram.types import Message
from aiogram.fsm.context import FSMContext
from aiogram.fsm.state import StatesGroup, State

from utils.api import check_telegram_user, create_vpn_user, get_token, set_telegram_to_vpn


class RegisterState(StatesGroup):
    reg_user = State()
    reset_tg = State()

router = Router()


@router.message(Command("reset_telegram"))
async def login_handler(message: Message, state: FSMContext):
    await message.answer("Введите ключ из личного кабинета:")
    await state.set_state(RegisterState.reset_tg)

@router.message(Command("register"))
async def register_handler(message: Message, state: FSMContext):
    user_id = message.from_user.id
    
    if await check_telegram_user(user_id):
        await message.answer("Вы уже зарегистрированы! Используйте команду /login для входа")
    else:
        await message.answer("Введите ключ из личного кабинета:")

        await state.set_state(RegisterState.reg_user)


@router.message(Command("account"))
async def account_handler(message: Message):
    user_id = message.from_user.id

    if not await check_telegram_user(user_id):
        await message.answer("Вы не зарегистрированы! Используйте команду /register для регистрации")
    
    else:

        user_data = await check_telegram_user(user_id)
        username = user_data["username"]
        private_key = user_data["private_key"]
        public_key = user_data["public_key"]
        telegram_id = user_data["telegram_id"]

        info_message = (
            f"<b>Имя пользователя:</b> {username}\n"
            f"<b>Приватный ключ:</b> <code>{private_key}</code>\n"
            f"<b>Публичный ключ:</b> <code>{public_key}</code>\n"
            f"<b>Телеграм ID:</b> {telegram_id}"
        )

        await message.answer("Информация о аккаунте:")
        await message.answer(info_message, parse_mode="HTML")


# States
@router.message(RegisterState.reg_user)
async def register_user_handler(message: Message, state: FSMContext):
    key = message.text

    user_id = message.from_user.id
    username, token = get_token(key)    

    if username is None or token is None:
        await message.answer("Неверный формат токена! Формат должен быть: user:token")
    else:
        await message.answer(f"User: {username}\nToken: {token}")

        resp_status, user_data = await create_vpn_user(token=token, username=username, telegram_id=user_id)

        print(user_data)
        if resp_status == 200:
            await message.answer(f"Вы успешно зарегистрированы(**{str(user_data["username"])}***)!")
            await message.answer("Используйте команду /account для получения информации о аккаунте")
        
        elif resp_status == 400:
            await message.answer(f"Аккаунт уже создан и привязан к другому телеграм аккаунту! Используйте команду /reset_telegram для смены аккаунта")

        else:
            await message.answer("Ошибка сервиса! Попробуйте позже!")

        print(resp_status)

    await state.clear()


@router.message(RegisterState.reset_tg)
async def reset_telegram_user_handler(message: Message, state: FSMContext):
    key = message.text

    user_id = message.from_user.id
    username, token = get_token(key)    

    if username is None or token is None:
        await message.answer("Неверный формат токена! Формат должен быть: user:token")
    else:
        await message.answer(f"User: {username}\nToken: {token}")

        resp_code, user_data = await set_telegram_to_vpn(token=token, username=username, telegram_id=user_id)

        username = user_data["username"]

        if resp_code == 200:
            await message.answer(f"Вы успешно привязали аккаунт {username} к вашему телеграм аккаунту!")
        elif resp_code == 404:
            await message.answer("Аккаунт не найден!")
        else:
            await message.answer("Ошибка сервиса! Попробуйте позже!")

    await state.clear()

