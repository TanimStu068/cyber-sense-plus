import 'package:cyber_sense_plus/features/auth/screens/login_screen.dart';
import 'package:cyber_sense_plus/features/settings/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import 'edit_profile_screen.dart';
import 'dart:io';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2233),
        elevation: 2,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PROFILE CARD (with Hive & auto rebuild)
            Consumer<ProfileProvider>(
              builder: (context, profileProvider, _) {
                final profile = profileProvider.profile;
                return Card(
                  color: const Color(0xFF1F2233),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 24,
                    ),
                    child: Row(
                      children: [
                        // Avatar (local file if exists, else fallback)
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: profile.avatarPath != null
                              ? FileImage(File(profile.avatarPath!))
                                    as ImageProvider
                              : const NetworkImage(
                                  "https://i.pravatar.cc/150?img=12",
                                ),
                        ),
                        const SizedBox(width: 16),
                        // Name & Email
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile.email,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.greenAccent,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EditProfileScreen(),
                              ),
                            );
                          },
                          tooltip: "Edit Profile",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // SETTINGS & LOGOUT
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.greenAccent),
              title: const Text(
                "Settings",
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white38,
                size: 16,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsScreen()),
                );
                // profileProvider.openSettings(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white38,
                size: 16,
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );

                // Navigator.pushNamedAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), predicate);
              },
            ),
          ],
        ),
      ),
    );
  }
}
