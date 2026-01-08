import 'package:cyber_sense_plus/core/contants/colors.dart';
import 'package:cyber_sense_plus/features/threat_news/screens/news_feed_screen.dart';
import 'package:cyber_sense_plus/features/breach_monitor/screens/breach_monitor_screen.dart';
import 'package:cyber_sense_plus/features/cyber_hygiene/screens/cyber_hygiene_home_screen.dart';
import 'package:cyber_sense_plus/features/incident_logbook/screens/incident_list_screen.dart';
import 'package:cyber_sense_plus/features/onboarding/screens/welcome_screen.dart';
import 'package:cyber_sense_plus/features/profile/screens/profile_screen.dart';
import 'package:cyber_sense_plus/features/settings/screens/about_app_screen.dart';
import 'package:cyber_sense_plus/features/settings/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundDark,
      child: SafeArea(
        child: Column(
          children: [
            _drawerHeader(),
            Expanded(
              child: ListView(
                children: [
                  _drawerItem(
                    icon: Icons.person,
                    title: "Profile",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProfileScreen()),
                      );
                    },
                  ),
                  _drawerItem(
                    icon: Icons.warning_amber_rounded,
                    title: "Breach Monitor",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BreachMonitorScreen(),
                        ),
                      );
                    },
                  ),
                  _drawerItem(
                    icon: Icons.newspaper,
                    title: "Threat News",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsFeedScreen(),
                        ),
                      );
                    },
                  ),
                  _drawerItem(
                    icon: Icons.shield,
                    title: "Cyber Hygiene",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CyberHygieneHomeScreen(),
                        ),
                      );
                    },
                  ),
                  _drawerItem(
                    icon: Icons.report,
                    title: "Incident Logbook",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => IncidentListScreen()),
                      );
                    },
                  ),
                  const Divider(color: Colors.white24),
                  _drawerItem(
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SettingsScreen()),
                      );
                    },
                  ),
                  _drawerItem(
                    icon: Icons.info_outline,
                    title: "About App",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AboutAppScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            _logoutTile(context),
          ],
        ),
      ),
    );
  }

  Widget _drawerHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryAccent.withOpacity(0.8),
            AppColors.backgroundDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.security, color: Colors.white, size: 40),
          SizedBox(height: 12),
          Text(
            "Cyber Sense",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Secure • Smart • Aware",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.cyanAccent),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      hoverColor: Colors.cyanAccent.withOpacity(0.08),
      onTap: onTap,
    );
  }

  Widget _logoutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.redAccent),
      title: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
      onTap: () async {
        // 1️⃣ Firebase logout
        await FirebaseAuth.instance.signOut();

        // 2️⃣ Drawer close (important)
        Navigator.pop(context);

        // 3️⃣ Navigate to Welcome screen & clear stack
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          (route) => false,
        );
      },
    );
  }
}
