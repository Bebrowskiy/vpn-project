import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Импортируем библиотеку
import 'settings_screen.dart';  // Импортируем экран настроек
import 'login_screen.dart';     // Импортируем экран для входа (для выхода)

class VpnScreen extends StatefulWidget {
  const VpnScreen({super.key});

  @override
  _VpnScreenState createState() => _VpnScreenState();
}

class _VpnScreenState extends State<VpnScreen> {
  bool isConnected = false;

  void toggleVpn() {
    setState(() {
      isConnected = !isConnected;
    });

    if (isConnected) {
      print('VPN подключен');
    } else {
      print('VPN отключен');
    }
  }

  // Метод для выхода из системы
  void logout() async {
    // Удаляем токен из SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    
    // Переходим на экран входа
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  // Метод для отображения диалогового окна с действиями для аккаунта
  void showAccountOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Управление аккаунтом'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Выход из системы'),
                onTap: () {
                  logout();
                  Navigator.pop(context);  // Закрываем диалог
                },
              ),
              // Можно добавить дополнительные действия с аккаунтом, например:
              // ListTile(
              //   title: Text('Изменить данные'),
              //   onTap: () {
              //     // Действие для изменения данных
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VPN'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: showAccountOptions,  // Переход на экран управления аккаунтом
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Переход на экран настроек
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: toggleVpn,
          child: Text(isConnected ? 'Отключиться от VPN' : 'Подключиться к VPN'),
        ),
      ),
    );
  }
}
