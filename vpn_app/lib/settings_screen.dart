import 'package:flutter/material.dart';
import 'hive_service.dart';

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) updateTheme;

  const SettingsScreen({super.key, required this.updateTheme});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await HiveService.getData('theme_mode');
    setState(() {
      _isDarkMode = savedTheme == 'dark';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Тема приложения',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Тёмная тема'),
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
                widget.updateTheme(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Дополнительные настройки',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Уведомления'),
              trailing: Switch(value: true, onChanged: null), // Заглушка
            ),
            const ListTile(
              leading: Icon(Icons.language),
              title: Text('Язык'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}