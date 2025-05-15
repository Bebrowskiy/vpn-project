import 'package:flutter/material.dart';
import 'api_client.dart';
import 'hive_service.dart';
import 'widgets/update_dialog.dart'; // Импортируем UpdateDialog

class VpnScreen extends StatefulWidget {
  const VpnScreen({super.key});

  @override
  _VpnScreenState createState() => _VpnScreenState();
}

class _VpnScreenState extends State<VpnScreen> {
  bool _isLoading = false;

  Future<void> _createVpnUser() async {
    setState(() {
      _isLoading = true;
    });

    final token = await HiveService.getData('access_token');
    if (token != null) {
      final response = await ApiClient.createVpnUser(token);
      if (response != null) {
        showMessage('VPN-пользователь создан успешно');
      } else {
        showMessage('Ошибка при создании VPN-пользователя');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _setTelegramId(String username, int telegramId) async {
    setState(() {
      _isLoading = true;
    });

    final token = await HiveService.getData('access_token');
    if (token != null) {
      final response = await ApiClient.setTelegramId(token, username, telegramId);
      if (response != null) {
        showMessage('Telegram ID успешно привязан');
      } else {
        showMessage('Ошибка при привязке Telegram ID');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление VPN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _createVpnUser,
                    child: const Text('Создать VPN-пользователя'),
                  ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final username = await showDialog<String>(
                  context: context,
                  builder: (context) => UpdateDialog(
                    title: 'Привязать Telegram ID',
                    hintText: 'Введите имя пользователя',
                  ),
                );
                final telegramIdString = await showDialog<String>(
                  context: context,
                  builder: (context) => UpdateDialog(
                    title: 'Привязать Telegram ID',
                    hintText: 'Введите Telegram ID',
                  ),
                );
                if (username != null && username.isNotEmpty && telegramIdString != null) {
                  final telegramId = int.tryParse(telegramIdString);
                  if (telegramId != null) {
                    _setTelegramId(username, telegramId);
                  } else {
                    showMessage('Некорректный Telegram ID');
                  }
                }
              },
              child: const Text('Привязать Telegram ID'),
            ),
          ],
        ),
      ),
    );
  }
}