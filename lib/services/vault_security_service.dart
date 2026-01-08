import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VaultSecurityService {
  final _storage = const FlutterSecureStorage();
  final String _pinKey = 'vault_pin';
  final String _pinSetKey = 'vault_pin_set';

  // Check if PIN is set
  Future<bool> isPinSet() async {
    final pinSet = await _storage.read(key: _pinSetKey);
    return pinSet == 'true';
  }

  // Save PIN
  Future<void> setPin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
    await _storage.write(key: _pinSetKey, value: 'true');
  }

  // Verify PIN
  Future<bool> verifyPin(String pin) async {
    final storedPin = await _storage.read(key: _pinKey);
    return storedPin == pin;
  }

  // Clear PIN (optional, for testing or logout)
  Future<void> clearPin() async {
    await _storage.delete(key: _pinKey);
    await _storage.delete(key: _pinSetKey);
  }
}
