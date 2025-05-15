import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_client.dart';
import 'hive_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profileData;
  String? _telegramToken; // Токен для привязки Telegram
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile(); // Автоматическая проверка привязки Telegram при загрузке страницы
  }

  // Получение данных профиля с сервера
  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
    });

    final token = await HiveService.getData('access_token');
    if (token != null) {
      final data = await ApiClient.getProfile(token);
      if (data != null) {
        setState(() {
          profileData = data; // Обновляем данные профиля
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Генерация токена для привязки Telegram
  Future<void> _generateTelegramToken() async {
    final token = await HiveService.getData('access_token');
    if (token != null) {
      final response = await ApiClient.generateTelegramToken(token);
      if (response != null) {
        setState(() {
          _telegramToken = response['access_token']; // Сохраняем активный токен
        });

        // Копирование токена в буфер обмена
        await Clipboard.setData(ClipboardData(text: _telegramToken!));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Токен скопирован. Отправьте его боту.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при генерации токена')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Аватар пользователя
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF6C5CE7),
                    child: Text(
                      profileData?['username']?[0].toUpperCase() ?? '',
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Имя пользователя
                  Text(
                    profileData?['username'] ?? 'Пользователь',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Email
                  Text(
                    profileData?['email'] ?? 'Email не указан',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // Telegram ID или кнопка для привязки
                  if (profileData?['telegram_id'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Telegram ID:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profileData?['telegram_id'].toString() ?? '',
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Привяжите ваш Telegram для использования всех функций',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _generateTelegramToken,
                          icon: const Icon(Icons.telegram, size: 18),
                          label: const Text('Скопировать токен'),
                        ),
                        if (_telegramToken != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Активный токен: $_telegramToken',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),

                  const SizedBox(height: 32),

                  // Выход из аккаунта
                  ElevatedButton.icon(
                    onPressed: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Выход из системы'),
                          content: const Text('Вы уверены, что хотите выйти из аккаунта?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Отмена', style: TextStyle(color: Color(0xFF6C5CE7))),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Выйти', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (shouldLogout == true) {
                        await HiveService.deleteData('access_token');
                        await HiveService.deleteData('username');
                        await HiveService.deleteData('email');

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Вы успешно вышли из системы')),
                        );
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Выйти из аккаунта'),
                  ),
                ],
              ),
            ),
    );
  }
}