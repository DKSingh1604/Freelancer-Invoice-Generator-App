import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.deepPurple,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isDark ? Icons.dark_mode : Icons.light_mode,
              size: 64,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 24),
            Text(
              _isDark ? 'Dark Theme' : 'Light Theme',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
              label: Text(
                _isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
              ),
              onPressed: () {
                setState(() {
                  _isDark = !_isDark;
                });
                // Use InheritedWidget, Provider, or similar for app-wide theme in a real app
              },
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Note: This only changes theme for this page. For full app theming, use Provider or similar.',
              ),
            ),
          ],
        ),
      ),
      backgroundColor: _isDark ? const Color(0xFF23223A) : Colors.white,
    );
  }
}
