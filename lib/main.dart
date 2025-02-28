import 'package:flutter/material.dart';
import 'vpn_screen.dart';
import 'auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPN App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Стартовый экран
      routes: {
        '/': (context) => AuthScreen(),  // Экран аутентификации
        '/vpn': (context) => VpnScreen(),  // Экран VPN
      },
    );
  }
}
