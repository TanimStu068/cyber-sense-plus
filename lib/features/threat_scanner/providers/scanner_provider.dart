import 'package:cyber_sense_plus/core/utils/qr_utils.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class ScanResult {
  final String url;
  final String result;

  ScanResult({required this.url, required this.result});
}

class ScannerProvider extends ChangeNotifier {
  bool _isScanning = false;
  bool get isScanning => _isScanning;

  /// Stores recent scan results
  final List<ScanResult> _recentScans = [];
  List<ScanResult> get recentScans => List.unmodifiable(_recentScans);

  /// Simulated URL threat check
  Future<String> scanUrl(String url) async {
    _isScanning = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // simulate scanning delay

    _isScanning = false;
    notifyListeners();

    final result =
        (url.toLowerCase().contains("phish") ||
            url.toLowerCase().contains("malware"))
        ? "⚠️ Malicious detected!"
        : "✅ Safe to visit";

    // Save to recent scans
    _recentScans.add(ScanResult(url: url, result: result));
    if (_recentScans.length > 10) {
      _recentScans.removeAt(0);
    }

    return result;
  }

  Future<String> analyzeQr(String data) async {
    final type = detectQrType(data);

    switch (type) {
      case QrType.url:
        return scanUrl(data);

      case QrType.wifi:
        final wifi = parseWifiQr(data);
        return "WARNING: 📶 Wi-Fi detected\nSSID: ${wifi['S']}\nSecurity: ${wifi['T']}";

      case QrType.payment:
        return "DANGER: 🚨 Payment QR detected. Verify recipient carefully.";

      case QrType.phone:
        return "WARNING: 📞 Phone number detected";

      case QrType.sms:
        return "WARNING: 💬 SMS QR detected";

      case QrType.email:
        return "ℹ️ Email QR detected";

      default:
        return "ℹ️ No immediate threat detected";
    }
  }

  /// Optionally launch the URL in browser
  Future<void> launchUrlInBrowser(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
