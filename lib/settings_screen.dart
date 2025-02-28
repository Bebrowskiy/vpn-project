import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _serverController = TextEditingController();
  final TextEditingController _portController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки VPN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поле для ввода адреса сервера
            TextField(
              controller: _serverController,
              decoration: InputDecoration(
                labelText: 'Адрес сервера',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16), // отступ

            // Поле для ввода порта
            TextField(
              controller: _portController,
              decoration: InputDecoration(
                labelText: 'Порт',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Кнопка для сохранения настроек
            ElevatedButton(
              onPressed: () {
                final server = _serverController.text;
                final port = _portController.text;

                if (server.isNotEmpty && port.isNotEmpty) {
                  // Логика для сохранения настроек (например, сохранить в SharedPreferences или передать серверу)
                  print('Сервер: $server, Порт: $port');
                } else {
                  // Показать сообщение об ошибке, если поля пустые
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
                }
              },
              child: Text('Сохранить настройки'),
            ),
          ],
        ),
      ),
    );
  }
}
