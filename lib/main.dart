import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vpn_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token'); // Получаем сохраненный токен
  print(token);
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  MyApp({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPN App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: token != null ? VpnScreen() : LoginScreen(), // Выбираем стартовый экран
      routes: {
        '/register': (context) => RegisterScreen(), // Экран регистрации'
        '/vpn': (context) => VpnScreen(), // Экран VPN
      },
    );
  }
}
