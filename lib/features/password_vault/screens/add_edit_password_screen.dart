import 'package:cyber_sense_plus/core/widgets/custom_button.dart';
import 'package:cyber_sense_plus/models/password_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddEditPasswordScreen extends StatefulWidget {
  final PasswordModel? password; // null = add, non-null = edit

  const AddEditPasswordScreen({super.key, this.password});

  @override
  State<AddEditPasswordScreen> createState() => _AddEditPasswordScreenState();
}

class _AddEditPasswordScreenState extends State<AddEditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _notesController;
  bool _isPasswordVisible = false;
  double _passwordStrength = 0; // 0 to 1
  String? _selectedAccountType;

  final List<String> accountTypes = [
    'Social',
    'Banking',
    'Work',
    'Email',
    'Shopping',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.password?.title ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.password?.username ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.password?.password ?? '',
    );
    _notesController = TextEditingController(
      text: widget.password?.notes ?? '',
    );
    // Initialize the account type here
    _selectedAccountType = widget.password?.accountType;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _savePassword() async {
    if (_formKey.currentState!.validate()) {
      final newPassword = PasswordModel(
        id: widget.password?.id ?? DateTime.now().toString(),
        title: _titleController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        notes: _notesController.text.trim(),
        createdAt: widget.password?.createdAt ?? DateTime.now(),
        updatedAt: widget.password != null ? DateTime.now() : null,
        accountType: _selectedAccountType, // NEW
      );

      // Open the Hive box
      var box = Hive.box<PasswordModel>('passwords');

      if (widget.password == null) {
        // Add new password
        await box.put(newPassword.id, newPassword);
      } else {
        // Update existing password
        await box.put(newPassword.id, newPassword);
      }

      // Close the screen and return the saved password (optional)
      Navigator.pop(context, newPassword);
    }
  }

  void _generatePassword() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+-=';
    String password = List.generate(
      16,
      (index) => chars[(DateTime.now().microsecond + index) % chars.length],
    ).join();

    // Just update the controller text; password strength will update automatically
    _passwordController.text = password;

    // Make password visible safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _isPasswordVisible = true;
        _passwordStrength = 1.0; // full strength for generated password
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.password == null ? "Add Password" : "Edit Password",
          style: GoogleFonts.montserrat(
            color: Colors.cyanAccent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title
              _buildTextField(
                controller: _titleController,
                label: "Title",
                hint: "e.g., Google Account",
                icon: Icons.lock,
              ),
              const SizedBox(height: 16),

              // Username / Email
              _buildTextField(
                controller: _usernameController,
                label: "Username / Email",
                hint: "e.g., johndoe@gmail.com",
                icon: Icons.person,
              ),
              const SizedBox(height: 16),

              // Password with show/hide and generate button
              _buildPasswordField(),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: _selectedAccountType,
                decoration: InputDecoration(
                  labelText: "Account Type",
                  labelStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                dropdownColor: AppColors.backgroundDark,
                items: accountTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAccountType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select account type';
                  }
                  return null;
                },
              ),
              FlutterPasswordStrength(
                password: _passwordController.text,
                strengthCallback: (strength) {
                  // Wrap in addPostFrameCallback to avoid setState during build
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    setState(() {
                      _passwordStrength = strength;
                    });
                  });
                },
                height: 8,
                radius: 8,
              ),

              const SizedBox(height: 4),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _passwordStrength < 0.3
                      ? "Weak password"
                      : _passwordStrength < 0.7
                      ? "Medium strength"
                      : "Strong password",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _passwordStrength < 0.3
                        ? Colors.redAccent
                        : _passwordStrength < 0.7
                        ? Colors.orangeAccent
                        : Colors.greenAccent,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Notes
              _buildTextField(
                controller: _notesController,
                label: "Notes",
                hint: "Optional notes...",
                icon: Icons.note,
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Save Button
              CustomButton(
                text: widget.password == null
                    ? "Save Password"
                    : "Update Password",
                onPressed: _savePassword,
                height: 55,
                borderRadius: 16,
                gradient: const LinearGradient(
                  colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if ((value ?? '').isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white54),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: AppColors.primaryAccent),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if ((value ?? '').isEmpty) return 'Please enter password';
        if ((value ?? '').length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(color: Colors.white54),
        hintText: "Enter password",
        hintStyle: TextStyle(color: Colors.white38),
        prefixIcon: Icon(Icons.lock, color: AppColors.primaryAccent),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: _generatePassword,
              icon: const Icon(Icons.auto_fix_high, color: Colors.orangeAccent),
              tooltip: 'Generate Password',
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white54,
              ),
            ),
          ],
        ),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
