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
      _showDialog('Ошибка', 'Пожалуйста, заполните все поля');
      return;
    }

    // Формируем данные для отправки
    final Map<String, String> userData = {
      'username': username,
      'email': email,
      'password': password,
    };

    final uri = Uri.parse('http://192.168.0.54:8000/api/register'); // Адрес сервера

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Токен: ${responseData['access_token']}'); // Можно сохранить токен

        // Показываем сообщение об успешной регистрации
        _showDialog('Успех', 'Регистрация успешна! Перенаправление...', onClose: () {
          Navigator.pushReplacementNamed(context, '/'); // Перенаправление на экран входа
        });
      } else {
        _showDialog('Ошибка', 'Не удалось зарегистрировать пользователя');
      }
    } catch (e) {
      _showDialog('Ошибка', 'Произошла ошибка: $e');
    }
  }

  // Метод для отображения диалогового окна
  void _showDialog(String title, String message, {VoidCallback? onClose}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onClose != null) onClose(); // Если передана функция, выполняем её
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Имя пользователя', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Электронная почта', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Пароль', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
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
