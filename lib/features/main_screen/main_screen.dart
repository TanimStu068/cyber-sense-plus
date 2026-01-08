import 'package:cyber_sense_plus/features/main_screen/app_drawer.dart';
import 'package:cyber_sense_plus/features/secure_notes/screens/notes_list_screen.dart';
import 'package:cyber_sense_plus/features/threat_scanner/screens/threat_scanner_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import 'package:cyber_sense_plus/features/dashboard/screens/dashboard_screen.dart';
import 'package:cyber_sense_plus/features/password_vault/screens/password_list_screen.dart';
import 'package:cyber_sense_plus/features/network_safety/screens/network_home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const PasswordListScreen(),
    const ThreatScannerHomeScreen(),
    const NetworkHomeScreen(),
    const NotesListScreen(),
  ];

  final List<String> _titles = [
    "Dashboard",
    "Passwords",
    "Threat Scanner",
    "Network Safety",
    "Secure Notes",
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        iconTheme: const IconThemeData(
          color: Colors.cyanAccent, // 👈 drawer icon color
        ),
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.backgroundDark,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primaryAccent,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.lock), label: "Passwords"),
          BottomNavigationBarItem(icon: Icon(Icons.radar), label: "Scanner"),
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi_protected_setup),
            label: "Network",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.note_alt), label: "Notes"),
        ],
      ),
    );
  }
}
