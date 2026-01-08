import 'package:cyber_sense_plus/core/widgets/custom_button.dart';
import 'package:cyber_sense_plus/features/password_vault/screens/add_edit_password_screen.dart';
import 'package:cyber_sense_plus/models/password_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import 'package:provider/provider.dart';
import 'package:cyber_sense_plus/features/password_vault/providers/password_provider.dart';

class PasswordDetailScreen extends StatefulWidget {
  final PasswordModel password;

  const PasswordDetailScreen({super.key, required this.password});

  @override
  State<PasswordDetailScreen> createState() => _PasswordDetailScreenState();
}

class _PasswordDetailScreenState extends State<PasswordDetailScreen> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Password Details',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Text(
              widget.password.title,
              style: GoogleFonts.montserrat(
                color: AppColors.primaryAccent,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Username / Email
            _infoCard(
              label: 'Username / Email',
              value: widget.password.username,
              icon: Icons.person,
              color: Colors.cyanAccent,
            ),
            const SizedBox(height: 12),

            // Password
            _infoCard(
              label: 'Password',
              value: widget.password.password,
              icon: Icons.lock,
              color: Colors.redAccent,
              isPassword: true,
              showPassword: _showPassword,
              onToggleVisibility: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ),

            const SizedBox(height: 12),

            // Notes
            if (widget.password.notes.isNotEmpty)
              _infoCard(
                label: 'Notes',
                value: widget.password.notes,
                icon: Icons.note,
                color: Colors.greenAccent,
              ),
            const SizedBox(height: 20),

            // Created / Updated info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Created: ${_formatDate(widget.password.createdAt)}',
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Updated: ${widget.password.updatedAt != null ? _formatDate(widget.password.updatedAt!) : "-"}',
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Edit',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddEditPasswordScreen(password: widget.password),
                        ),
                      );
                    },
                    height: 55,
                    borderRadius: 16,
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryAccent,
                        AppColors.secondaryAccent,
                      ],
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Delete',
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColors.backgroundDark,
                          title: const Text(
                            'Delete Password?',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            'This action cannot be undone.',
                            style: TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await context.read<PasswordProvider>().deletePassword(
                          widget.password.id,
                        );

                        if (mounted) {
                          Navigator.pop(context); // back to password list
                        }
                      }
                    },
                    height: 55,
                    borderRadius: 16,
                    gradient: const LinearGradient(
                      colors: [Colors.redAccent, Colors.red],
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Widget _infoCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    bool isPassword = false,
    bool showPassword = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              isPassword ? (showPassword ? value : '●●●●●●●●') : value,
              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
            ),
          ),
          if (isPassword)
            GestureDetector(
              onTap: onToggleVisibility,
              child: Icon(
                showPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
              ),
            ),
        ],
      ),
    );
  }
}
