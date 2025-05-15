import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'http://192.168.0.54:8000/api'; // Замените на реальный IP-адрес сервера

  // Регистрация пользователя
  static Future<Map<String, dynamic>?> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      
      // Логируем ответ сервера для отладки
      print('Ответ сервера при регистрации: $responseData');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Успешная регистрация
        return responseData;
      } else {
        // Обработка ошибок от сервера
        print('Ошибка регистрации (${response.statusCode}): ${response.body}');
        return null;
      }
    } on FormatException catch (e) {
      print('Ошибка формата ответа от сервера: $e');
      return null;
    } on http.ClientException catch (e) {
      print('Ошибка подключения к серверу: $e');
      rethrow; // Пробрасываем исключение дальше для обработки в UI
    } catch (e) {
      print('Неизвестная ошибка при регистрации: $e');
      rethrow; // Пробрасываем исключение дальше для обработки в UI
    }
  }

  // Авторизация пользователя
  static Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Failed to login. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  // Получение профиля пользователя
  static Future<Map<String, dynamic>?> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Failed to fetch profile. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  // Обновление данных профиля
  static Future<Map<String, dynamic>?> updateProfile(String token, {String? email, String? password}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/profile/update'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({
          if (email != null) 'email': email,
          if (password != null) 'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error updating profile: $e');
      return null;
    }
  }

  // Создание VPN-пользователя
  static Future<Map<String, dynamic>?> createVpnUser(String token, {int? telegramId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/vpn/create/'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({
          if (telegramId != null) 'telegram_id': telegramId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Failed to create VPN user. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error creating VPN user: $e');
      return null;
    }
  }

  // Привязка Telegram ID
  static Future<Map<String, dynamic>?> setTelegramId(String token, String username, int telegramId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/vpn/$username/set-telegram/'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({'telegram_id': telegramId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Failed to set Telegram ID. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error setting Telegram ID: $e');
      return null;
    }
  }

  // Генерация токена для привязки Telegram
  static Future<Map<String, dynamic>?> generateTelegramToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/generate-telegram-token?token=$token'), // URL эндпоинта
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error generating Telegram token: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception while generating Telegram token: $e');
      return null;
    }
  }
}

