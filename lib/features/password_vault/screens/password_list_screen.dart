import 'package:cyber_sense_plus/features/password_vault/screens/lock_screen.dart';
import 'package:cyber_sense_plus/features/password_vault/screens/password_detail_screen.dart';
import 'package:cyber_sense_plus/models/password_model.dart';
import 'package:cyber_sense_plus/services/vault_security_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'add_edit_password_screen.dart';

class PasswordListScreen extends StatefulWidget {
  const PasswordListScreen({super.key});

  @override
  State<PasswordListScreen> createState() => _PasswordListScreenState();
}

class _PasswordListScreenState extends State<PasswordListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PasswordModel> _passwords = [];
  List<PasswordModel> _filteredPasswords = [];
  late Box<PasswordModel> _passwordBox;
  final VaultSecurityService _vaultService = VaultSecurityService();
  bool _isUnlocked = false;
  String _selectedCategory = 'All'; // default category
  final List<String> categories = [
    'All',
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
    _initHive().then((_) => _checkPin());
  }

  void _checkPin() async {
    final pinSet = await _vaultService.isPinSet();

    if (!pinSet) {
      // Ask user to create a PIN
      final pin = await _showSetPinDialog();
      if (pin != null && pin.length == 6) {
        await _vaultService.setPin(pin);
      }
    }

    // Show lock screen until unlocked
    setState(() {
      _isUnlocked = false;
    });
  }

  Future<String?> _showSetPinDialog() async {
    String? pin;
    final controller = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent, // remove default dialog background
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D0D0D), Color(0xFF1A1A1A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.cyanAccent.withOpacity(0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.2),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔒 Icon
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.cyanAccent.withOpacity(0.1),
                child: Icon(
                  Icons.lock_outline,
                  color: Colors.cyanAccent,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                'Set 6-digit PIN',
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              // PIN Input
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                maxLength: 6,
                obscureText: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
                decoration: InputDecoration(
                  counterText: '', // remove counter
                  filled: true,
                  fillColor: Colors.white12,
                  hintText: 'Enter PIN',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.cyanAccent, width: 2),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Save Button
              GestureDetector(
                onTap: () {
                  pin = controller.text;
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00E5FF), Color(0xFF8C3EFF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.4),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Save PIN',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return pin;
  }

  void _unlockVault() {
    setState(() {
      _isUnlocked = true;
    });
  }

  Future<void> _initHive() async {
    // Open the Hive box (already opened in main.dart)
    _passwordBox = Hive.box<PasswordModel>('passwords');

    // Load all passwords
    _loadPasswords();

    // Listen for changes in Hive and update the UI automatically
    _passwordBox.watch().listen((event) {
      _loadPasswords();
    });
  }

  void _loadPasswords() {
    setState(() {
      _passwords = _passwordBox.values.toList();
      _filteredPasswords = List.from(_passwords);
    });
    _filterPasswords();
  }

  void _filterPasswords([String? query]) {
    final searchQuery = query ?? _searchController.text;

    setState(() {
      _filteredPasswords = _passwords.where((p) {
        final matchesSearch =
            p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            p.username.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesCategory =
            _selectedCategory == 'All' || p.accountType == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUnlocked) {
      return LockScreen(onAuthenticated: _unlockVault);
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: TextField(
              controller: _searchController,
              onChanged: _filterPasswords,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search passwords...',
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: AppColors.primaryAccent),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          //filter bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: categories.map((category) {
                final isSelected = category == _selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                    _filterPasswords();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                AppColors.primaryAccent,
                                AppColors.secondaryAccent,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : Colors.white12,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.white12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Password List
          Expanded(
            child: _filteredPasswords.isEmpty
                ? Center(
                    child: Text(
                      "No passwords found",
                      style: GoogleFonts.montserrat(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredPasswords.length,
                    itemBuilder: (context, index) {
                      final password = _filteredPasswords[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PasswordDetailScreen(password: password),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryAccent.withOpacity(0.3),
                                AppColors.secondaryAccent.withOpacity(0.3),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white12,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    password.title,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    password.username,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddEditPasswordScreen(
                                        password: password,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditPasswordScreen()),
          );
        },
        backgroundColor: AppColors.primaryAccent,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
