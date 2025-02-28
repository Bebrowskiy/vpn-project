import 'package:flutter/material.dart';
import 'settings_screen.dart';  // Импортируем экран настроек

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VPN'),
        actions: [
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
