import 'package:flutter/material.dart';
import 'api_client.dart';
import 'hive_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, dynamic>? profileData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
    });

    final token = await HiveService.getData('access_token');
    if (token != null) {
      final data = await ApiClient.getProfile(token);
      if (data != null) {
        setState(() {
          profileData = data;
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

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Выход из системы'),
            content: const Text('Вы уверены, что хотите выйти из аккаунта?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Отмена',
                  style: TextStyle(color: Color(0xFF6C5CE7)),
                ),
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

      print('User logged out successfully');
      showMessage('Вы успешно вышли из системы');
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VPN App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Выйти',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(profileData?['username'] ?? 'Пользователь'),
              accountEmail: Text(profileData?['email'] ?? 'Email не указан'),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/avatar.png',
                ), // Добавьте изображение
              ),
              decoration: const BoxDecoration(color: Color(0xFF6C5CE7)),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF6C5CE7)),
              title: const Text('Профиль'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF6C5CE7)),
              title: const Text('Настройки'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Выйти'),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedIconWidget(),
                    const SizedBox(height: 16),
                    const Text(
                      'Статус VPN:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Не подключён',
                      style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        showMessage(
                          'Функция подключения к VPN пока недоступна',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C5CE7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.vpn_key, size: 24),
                      label: const Text(
                        'Подключиться к VPN',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

// Анимированная иконка
class AnimatedIconWidget extends StatefulWidget {
  const AnimatedIconWidget({super.key});

  @override
  _AnimatedIconWidgetState createState() => _AnimatedIconWidgetState();
}

class _AnimatedIconWidgetState extends State<AnimatedIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: ScaleTransition(
        scale: _animation,
        child: const Icon(Icons.vpn_lock, size: 100, color: Color(0xFF6C5CE7)),
      ),
    );
  }
}
