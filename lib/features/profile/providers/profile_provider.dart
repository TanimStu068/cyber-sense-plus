import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_sense_plus/models/user_profile_hive.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

/// Profile Model
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? avatarPath; // local file path

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.avatarPath,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    String? avatarPath,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}

/// Profile Provider
class ProfileProvider extends ChangeNotifier {
  final _uuid = const Uuid();
  final Box profileBox = Hive.box('profileBox');

  ProfileProvider() {
    loadProfile();
  }

  void loadProfile() {
    final data = profileBox.get('profile');

    if (data != null && data is UserProfileHive) {
      _profile = _fromHive(data);
      notifyListeners();
    }
  }

  /// Fetch profile from Firebase and save to Hive
  Future<void> fetchProfileFromFirebase(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _profile = UserProfile(
          id: uid,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          phone: data['phone'] ?? '',
          role: data['role'] ?? '',
          avatarPath: data['avatarPath'],
        );
        _saveToHive(); // Save locally
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
  }

  void _saveToHive() {
    profileBox.put('profile', _toHive(_profile));
  }

  /// Initial dummy profile (can be replaced with Firebase later)
  UserProfile _profile = UserProfile(
    id: const Uuid().v4(),
    name: "Cyber Analyst",
    email: "analyst@cybersense.app",
    phone: "+880 1XXXXXXXXX",
    role: "Security Researcher",
    avatarPath: null,
  );

  UserProfile _fromHive(UserProfileHive hive) {
    return UserProfile(
      id: hive.id,
      name: hive.name,
      email: hive.email,
      phone: hive.phone,
      role: hive.role,
      avatarPath: hive.avatarPath,
    );
  }

  UserProfileHive _toHive(UserProfile profile) {
    return UserProfileHive(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      phone: profile.phone,
      role: profile.role,
      avatarPath: profile.avatarPath,
    );
  }

  /// Getter
  UserProfile get profile => _profile;

  /// Update profile details
  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    _profile = _profile.copyWith(name: name, email: email, phone: phone);
    _saveToHive();
    notifyListeners();
  }

  /// Update avatar
  void updateAvatar(String imagePath) {
    _profile = _profile.copyWith(avatarPath: imagePath);
    _saveToHive();
    notifyListeners();
  }

  /// Update role (optional future use)
  void updateRole(String role) {
    _profile = _profile.copyWith(role: role);
    _saveToHive();
    notifyListeners();
  }

  /// Reset profile (for logout or account deletion)
  void clearProfile() {
    _profile = UserProfile(
      id: _uuid.v4(),
      name: "",
      email: "",
      phone: "",
      role: "",
      avatarPath: null,
    );
    profileBox.delete('profile');
    notifyListeners();
  }
}
