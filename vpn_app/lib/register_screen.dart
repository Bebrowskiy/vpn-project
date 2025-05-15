import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_client.dart';
import 'hive_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Метод для завершения регистрации
  Future<void> register() async {
    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пожалуйста, заполните все поля')),
        );
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(email)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Некорректный формат электронной почты')),
        );
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    if (password.length < 6) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пароль должен содержать минимум 6 символов')),
        );
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    try {
      // Отправляем данные на сервер через ApiClient
      final response = await ApiClient.register(username, email, password);
      
      if (mounted) {
        if (response != null) {
          // Сохраняем токен и имя пользователя
          final token = response['access_token'];
          if (token != null) {
            await HiveService.saveData('access_token', token);
            await HiveService.saveData('username', username);
            
            // Показываем сообщение об успешной регистрации
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Вы успешно зарегистрированы!')),
            );
            
            // Перенаправляем на главный экран
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/main');
            }
          } else {
            // Если токен не пришел в ответе
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ошибка: не удалось получить токен доступа')),
              );
            }
          }
        } else {
          // Если произошла ошибка при регистрации
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ошибка регистрации. Пожалуйста, попробуйте снова.')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при подключении к серверу: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Имя пользователя'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Электронная почта'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Пароль'),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: register,
                    child: const Text('Зарегистрироваться'),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Уже есть аккаунт? Войти'),
            ),
          ],
        ),
      ),
    );
  }
}