import 'package:cyber_sense_plus/services/vault_security_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LockScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const LockScreen({super.key, required this.onAuthenticated});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final VaultSecurityService _vaultService = VaultSecurityService();
  final LocalAuthentication _localAuth = LocalAuthentication();
  final TextEditingController _pinController = TextEditingController();

  bool _isAuthenticating = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkBiometric(); // optional
  }

  void _checkBiometric() async {
    final canCheckBiometrics = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();

    if (canCheckBiometrics && isDeviceSupported) {
      _authenticateBiometric();
    }
  }

  void _authenticateBiometric() async {
    try {
      setState(() {
        _isAuthenticating = true;
      });
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Unlock Password Vault',
        biometricOnly: true,
      );

      if (authenticated) {
        widget.onAuthenticated();
      }
    } on PlatformException catch (e) {
      setState(() {
        _errorMessage = 'Biometric error: ${e.message}';
      });
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _verifyPin() async {
    final pin = _pinController.text;
    final valid = await _vaultService.verifyPin(pin);

    if (valid) {
      widget.onAuthenticated();
    } else {
      setState(() {
        _errorMessage = 'Incorrect PIN';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter PIN to unlock',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 20),

              IconButton(
                icon: Icon(
                  Icons.fingerprint,
                  size: 48,
                  color: Colors.cyanAccent,
                ),
                onPressed: _authenticateBiometric,
              ),
              PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: true,
                obscuringCharacter: '●',
                textStyle: const TextStyle(
                  color: Colors.cyanAccent, // The dot color
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeFillColor: Colors.deepPurple.withOpacity(0.3),
                  selectedFillColor: Colors.deepPurpleAccent.withOpacity(0.5),
                  inactiveFillColor: Colors.white10,
                  activeColor: Colors.cyanAccent,
                  selectedColor: Colors.cyanAccent,
                  inactiveColor: Colors.white24,
                ),
                cursorColor: Colors.cyanAccent,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                onChanged: (_) {},
                controller: _pinController,
              ),
              const SizedBox(height: 12),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A0DAD), Color(0xFF00FFFF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _verifyPin,
                    child: const Center(
                      child: Text(
                        'Unlock',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
