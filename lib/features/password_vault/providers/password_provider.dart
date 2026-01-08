import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cyber_sense_plus/models/password_model.dart';

class PasswordProvider extends ChangeNotifier {
  late Box<PasswordModel> _passwordBox;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// MUST be called once when app starts
  Future<void> init() async {
    _passwordBox = Hive.box<PasswordModel>('passwords');
    notifyListeners();
  }

  /// Get all passwords
  List<PasswordModel> get passwords {
    return _passwordBox.values.toList();
  }

  /// Add new password
  Future<void> addPassword(PasswordModel password) async {
    _isLoading = true;
    notifyListeners();

    await _passwordBox.put(password.id, password);

    _isLoading = false;
    notifyListeners();
  }

  /// Update existing password
  Future<void> updatePassword(String id, PasswordModel updatedPassword) async {
    _isLoading = true;
    notifyListeners();

    await _passwordBox.put(
      id,
      updatedPassword.copyWith(updatedAt: DateTime.now()),
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Delete password
  Future<void> deletePassword(String id) async {
    _isLoading = true;
    notifyListeners();

    await _passwordBox.delete(id);

    _isLoading = false;
    notifyListeners();
  }

  /// Get password by ID
  PasswordModel? getPasswordById(String id) {
    return _passwordBox.get(id);
  }

  /// Search passwords
  List<PasswordModel> searchPasswords(String query) {
    final lowerQuery = query.toLowerCase();

    return passwords.where((p) {
      return p.title.toLowerCase().contains(lowerQuery) ||
          p.username.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Clear all passwords (for testing / reset)
  Future<void> clearAll() async {
    await _passwordBox.clear();
    notifyListeners();
  }
}
