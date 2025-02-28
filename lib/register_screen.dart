import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Метод для отправки данных на сервер
  Future<void> register() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    // Валидация данных
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      // Показываем ошибку, если одно из полей пустое
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка'),
          content: Text('Пожалуйста, заполните все поля'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Формируем данные для отправки на сервер
    final Map<String, String> userData = {
      'username': username,
      'email': email,
      'password': password,
    };

    final uri = Uri.parse('http://192.168.0.54:8000/api/register');  // Указание адреса сервера

    try {
      // Отправляем данные на сервер
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final accessToken = responseData['access_token'];
        print('Токен: $accessToken'); // Выводим токен, если нужно

        // Можно сохранить токен в SharedPreferences или в другом месте для дальнейшего использования

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Успех'),
            content: Text('Пользователь зарегистрирован'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Не удалось зарегистрировать пользователя');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка'),
          content: Text('Произошла ошибка при регистрации: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поле для ввода имени пользователя
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Имя пользователя',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Поле для ввода электронной почты
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Электронная почта',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Поле для ввода пароля
            TextField(
              controller: _passwordController,
              obscureText: true,  // Скрыть текст пароля
              decoration: InputDecoration(
                labelText: 'Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Кнопка для отправки данных регистрации
            ElevatedButton(
              onPressed: register,
              child: Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}
