import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import 'package:cyber_sense_plus/features/onboarding/screens/welcome_screen.dart';
import 'package:cyber_sense_plus/models/incident_model.dart';
import 'package:cyber_sense_plus/models/note_model.dart';
import 'package:cyber_sense_plus/models/password_model.dart';
import 'package:cyber_sense_plus/services/vault_security_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'privacy_policy_screen.dart';
import 'help_support_screen.dart';
import 'about_app_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showChangePinDialog(BuildContext context) {
    final _oldPinController = TextEditingController();
    final _newPinController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final VaultSecurityService _vaultService = VaultSecurityService();
    bool _isLoading = false;
    String _errorMessage = '';

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Change PIN",
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return Center(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white12,
                        child: Icon(
                          Icons.lock_outline,
                          color: Colors.cyanAccent,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Change PIN",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _oldPinController,
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Enter old PIN",
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                                filled: true,
                                fillColor: Colors.white12,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.cyanAccent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.cyanAccent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return "Enter old PIN";
                                if (value.length != 6)
                                  return "PIN must be 6 digits";
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _newPinController,
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Enter new PIN",
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                                filled: true,
                                fillColor: Colors.white12,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.cyanAccent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.cyanAccent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return "Enter new PIN";
                                if (value.length != 6)
                                  return "PIN must be 6 digits";
                                return null;
                              },
                            ),
                            if (_errorMessage.isNotEmpty)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12,
                                ),
                                margin: const EdgeInsets.only(top: 12),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _errorMessage,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: _isLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;

                                setState(() {
                                  _isLoading = true;
                                  _errorMessage = '';
                                });

                                final isValidOldPin = await _vaultService
                                    .verifyPin(_oldPinController.text);

                                if (!isValidOldPin) {
                                  setState(() {
                                    _errorMessage = "Old PIN is incorrect";
                                    _isLoading = false;
                                  });
                                  return;
                                }

                                await _vaultService.setPin(
                                  _newPinController.text,
                                );

                                setState(() => _isLoading = false);
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("PIN changed successfully"),
                                  ),
                                );
                              },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primaryAccent,
                                AppColors.secondaryAccent,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Change PIN",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) => ScaleTransition(
        scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
        child: child,
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _isLoading = false;
    String _errorMessage = '';
    final VaultSecurityService _vaultService = VaultSecurityService();

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Delete Account",
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return Center(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white12,
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.redAccent,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Delete Account",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              "Enter your password to confirm:",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                                filled: true,
                                fillColor: Colors.white12,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.redAccent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter password";
                                }
                                return null;
                              },
                            ),
                            if (_errorMessage.isNotEmpty)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12,
                                ),
                                margin: const EdgeInsets.only(top: 12),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _errorMessage,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: _isLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;

                                setState(() {
                                  _isLoading = true;
                                  _errorMessage = '';
                                });

                                try {
                                  final user =
                                      FirebaseAuth.instance.currentUser!;
                                  final cred = EmailAuthProvider.credential(
                                    email: user.email!,
                                    password: _passwordController.text.trim(),
                                  );

                                  await user.reauthenticateWithCredential(cred);

                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .delete();

                                  await user.delete();

                                  await Hive.box<PasswordModel>(
                                    'passwords',
                                  ).clear();
                                  await Hive.box<NoteModel>('notesBox').clear();
                                  await Hive.box<Incident>('incidents').clear();

                                  await Hive.box('profileBox').clear();

                                  // Delete the vault PIN
                                  await _vaultService
                                      .clearPin(); // <-- ADD THIS LINE

                                  // Show success SnackBar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Account deleted successfully",
                                      ),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const WelcomeScreen(),
                                    ),
                                    (route) => false,
                                  );
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    _errorMessage =
                                        e.message ?? "Failed to delete account";
                                    _isLoading = false;
                                  });
                                }
                              },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.redAccent, Colors.red],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Delete Account",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) => ScaleTransition(
        scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isGoogleUser =
        user?.providerData.any((p) => p.providerId == 'google.com') ?? false;

    return Scaffold(
      // backgroundColor: ,
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        // backgroundColor: ,
        // foregroundColor: ,
        backgroundColor: const Color(0xFF1E1E2A),
        foregroundColor: Colors.cyanAccent,
        centerTitle: true,
        elevation: 2,
        title: Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// 📜 LEGAL & SUPPORT
            _sectionTitle("Legal & Support"),
            _cyberCard(
              context,
              child: Column(
                children: [
                  _settingsTile(
                    context,
                    icon: Icons.lock_outline,
                    title: "Change PIN",
                    onTap: () {
                      _showChangePinDialog(context);
                    },
                  ),

                  _settingsTile(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: "Privacy & Policy",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                  ),
                  _divider(context),
                  _settingsTile(
                    context,
                    icon: Icons.support_agent,
                    title: "Help & Support",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpSupportScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ℹ️ ABOUT
            _sectionTitle("Application"),
            _cyberCard(
              context,
              child: _settingsTile(
                context,
                icon: Icons.info_outline,
                title: "About Cyber Sense",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutAppScreen()),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // 🔴 Delete Account Button
            if (!isGoogleUser)
              _cyberCard(
                context,
                child: ListTile(
                  leading: const Icon(
                    Icons.delete_forever,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    "Delete Account",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    _showDeleteAccountDialog(context);
                  },
                ),
              ),

            const SizedBox(height: 32),

            /// 🚨 WARNING FOOTER
            Text(
              "Cyber Sense protects your digital awareness.\nAlways stay secure.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI COMPONENTS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00E5FF),
          ),
        ),
      ),
    );
  }

  Widget _cyberCard(BuildContext context, {required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF00E5FF).withOpacity(0.9),
            Color(0xFF8C3EFF).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(20), child: child),
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.greenAccent),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
      onTap: onTap,
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.6,
      color: Color(0xFFAAAAAA).withOpacity(0.2),
    );
  }
}
