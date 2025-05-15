import 'package:flutter/material.dart';
import 'hive_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await HiveService.getData('access_token');
    if (token != null) {
      // Токен существует — перенаправляем на MainScreen
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      // Токена нет — перенаправляем на LoginScreen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Проверка сессии...'),
          ],
        ),
      ),
    );
  }
}