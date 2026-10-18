import 'package:flutter/material.dart';

import 'screens/event_log_screen.dart';
import 'screens/live_cctv_screen.dart';
import 'screens/settings_screen.dart';
import 'services/ai_vision_engine.dart';

void main() {
  runApp(const SmartCctvApp());
}

class SmartCctvApp extends StatelessWidget {
  const SmartCctvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart AI CCTV Camera (15/10/2026)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.cyanAccent,
        scaffoldBackgroundColor: const Color(0xFF10141A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Colors.redAccent,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final AiVisionEngine _aiEngine = AiVisionEngine();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      LiveCctvScreen(aiEngine: _aiEngine),
      EventLogScreen(aiEngine: _aiEngine),
      SettingsScreen(aiEngine: _aiEngine),
    ];
  }

  @override
  void dispose() {
    _aiEngine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF1A212B),
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white54,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam_outlined),
            activeIcon: Icon(Icons.videocam),
            label: 'Live AI Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security_outlined),
            activeIcon: Icon(Icons.security),
            label: 'Alert Logs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune_outlined),
            activeIcon: Icon(Icons.tune),
            label: 'AI Settings',
          ),
        ],
      ),
    );
  }
}
