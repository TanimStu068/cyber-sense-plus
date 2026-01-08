import 'package:cyber_sense_plus/models/breach_model.dart';
import 'package:flutter/material.dart';

class BreachProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchBreaches() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // simulate API fetch

    // Example dummy data
    _breaches.clear();
    _breaches.addAll([
      BreachModel(
        id: '1',
        title: 'Acme Corp Data Leak',
        description: 'User credentials exposed due to server misconfig.',
        severity: 'High',
        date: DateTime.now(),
        affectedAccounts: ['user1@example.com'],
      ),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  final List<BreachModel> _breaches = [
    BreachModel(
      id: '1',
      title: 'Acme Corp Data Leak',
      description:
          'User credentials and emails were exposed due to a server misconfiguration.',
      severity: 'High',
      date: DateTime(2025, 12, 20),
      affectedAccounts: ['user1@example.com', 'user2@example.com'],
    ),
    BreachModel(
      id: '2',
      title: 'GlobalBank Breach',
      description:
          'Sensitive financial data was compromised via a phishing attack.',
      severity: 'Critical',
      date: DateTime(2025, 12, 15),
      affectedAccounts: ['john.doe@globalbank.com'],
    ),
    BreachModel(
      id: '3',
      title: 'SocialNet Leak',
      description: 'Profile information and passwords were exposed.',
      severity: 'Medium',
      date: DateTime(2025, 12, 10),
      affectedAccounts: ['alice@example.com', 'bob@example.com'],
    ),
  ];

  List<BreachModel> get breaches => List.unmodifiable(_breaches);

  /// Add a new breach
  void addBreach(BreachModel breach) {
    _breaches.add(breach);
    notifyListeners();
  }

  /// Update an existing breach
  void updateBreach(BreachModel updatedBreach) {
    final index = _breaches.indexWhere((b) => b.id == updatedBreach.id);
    if (index != -1) {
      _breaches[index] = updatedBreach;
      notifyListeners();
    }
  }

  /// Delete a breach by ID
  void deleteBreach(String id) {
    _breaches.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  /// Get breach by ID
  BreachModel? getBreachById(String id) {
    try {
      return _breaches.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search breaches by title or description
  List<BreachModel> searchBreaches(String query) {
    return _breaches
        .where(
          (b) =>
              b.title.toLowerCase().contains(query.toLowerCase()) ||
              b.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Filter breaches by severity (Low, Medium, High, Critical)
  List<BreachModel> filterBySeverity(String severity) {
    return _breaches.where((b) => b.severity == severity).toList();
  }

  /// Clear all breaches (optional, for debugging)
  void clearBreaches() {
    _breaches.clear();
    notifyListeners();
  }
}
