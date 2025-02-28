import 'package:flutter/material.dart';
import 'register_screen.dart'; // Импортируем экран регистрации

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Поле для ввода логина
            TextField(
              decoration: InputDecoration(
                labelText: 'Логин',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Поле для ввода пароля
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Кнопка для входа
            ElevatedButton(
              onPressed: () {
                // Логика аутентификации
                print('Авторизация...');
                Navigator.pushReplacementNamed(context, '/vpn');
              },
              child: Text('Войти'),
            ),
            SizedBox(height: 16),

            // Кнопка для перехода на экран регистрации
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Нет аккаунта? Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}
