import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'pick_bottle_screen.dart';
import 'send_bottle_screen.dart';
import 'my_bottles_screen.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PickBottleScreen(),
    const SendBottleScreen(),
    const MyBottlesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('时光漂流瓶'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: '捞取',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send_outlined),
            activeIcon: Icon(Icons.send),
            label: '发送',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox_outlined),
            activeIcon: Icon(Icons.inbox),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
