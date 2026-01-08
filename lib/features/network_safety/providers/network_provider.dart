import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:flutter_speed_test_plus/flutter_speed_test_plus.dart';

class NetworkModel {
  final String ssid;
  final String bssid;
  final String ip;
  final String gateway;
  final int frequency;
  final int signalLevel;
  final String encryption;
  final String threatLevel;
  final double downloadSpeed; // Mbps
  final double uploadSpeed; // Mbps
  final int ping; // ms

  NetworkModel({
    required this.ssid,
    required this.bssid,
    required this.ip,
    required this.gateway,
    required this.frequency,
    required this.signalLevel,
    required this.encryption,
    required this.threatLevel,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.ping,
  });
}

class NetworkProvider with ChangeNotifier {
  bool isLoading = false;
  NetworkModel? currentNetwork;
  double downloadSpeed = 0.0;
  double uploadSpeed = 0.0;
  bool isSpeedTestRunning = false;

  final NetworkInfo _networkInfo = NetworkInfo();

  /// Returns estimated max speed based on frequency
  double getMaxSpeed(int frequency) {
    if (frequency >= 5000) return 1300; // 5 GHz, AC/AX typical
    if (frequency >= 2400) return 450; // 2.4 GHz, N typical
    return 100; // fallback
  }

  /// Scan the currently connected network
  Future<void> scanNetwork() async {
    isLoading = true;
    currentNetwork = null; // 🔥 reset previous data
    notifyListeners();

    try {
      final ssid = await _networkInfo.getWifiName() ?? "Unknown";
      final bssid = await _networkInfo.getWifiBSSID() ?? "Unknown";
      final ip = await _networkInfo.getWifiIP() ?? "0.0.0.0";
      final gateway = await _networkInfo.getWifiGatewayIP() ?? "0.0.0.0";
      final freq = await WiFiForIoTPlugin.getFrequency() ?? 0;
      final signal = await WiFiForIoTPlugin.getCurrentSignalStrength() ?? -100;

      // Get encryption type
      String encryption = "Unknown";

      try {
        final wifiList = await WiFiForIoTPlugin.loadWifiList();

        for (final wifi in wifiList) {
          if (wifi.ssid == ssid) {
            encryption = wifi.capabilities ?? "Unknown";
            break;
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error getting encryption: $e");
        }
      }

      // Basic threat analysis
      final threat = _analyzeThreat(ssid, encryption);

      // Simulate speed test & ping (can replace with real tests)
      final download = await _simulateDownloadSpeed();
      final upload = await _simulateUploadSpeed();
      final pingValue = await _simulatePing();

      currentNetwork = NetworkModel(
        ssid: ssid,
        bssid: bssid,
        ip: ip,
        gateway: gateway,
        frequency: freq,
        signalLevel: signal,
        encryption: encryption,
        threatLevel: threat,
        downloadSpeed: download,
        uploadSpeed: upload,
        ping: pingValue,
      );
    } catch (e) {
      if (kDebugMode) print("Error scanning network: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// Run actual speed test using flutter_speed_test

  Future<void> runSpeedTest() async {
    if (currentNetwork == null || isSpeedTestRunning) return;

    isSpeedTestRunning = true;
    notifyListeners();

    try {
      final speedTester = FlutterInternetSpeedTest();

      speedTester.startTesting(
        useFastApi: true,

        onStarted: () {
          if (kDebugMode) {
            print("Speed test started...");
          }
        },

        onProgress: (percent, result) {
          if (kDebugMode) {
            print(
              "Progress: $percent%, Speed: ${result.transferRate} ${result.unit}",
            );
          }
        },

        onCompleted: (downloadResult, uploadResult) {
          downloadSpeed = downloadResult.transferRate;
          uploadSpeed = uploadResult.transferRate;

          // ✅ UPDATE currentNetwork with REAL speed results
          currentNetwork = NetworkModel(
            ssid: currentNetwork!.ssid,
            bssid: currentNetwork!.bssid,
            ip: currentNetwork!.ip,
            gateway: currentNetwork!.gateway,
            frequency: currentNetwork!.frequency,
            signalLevel: currentNetwork!.signalLevel,
            encryption: currentNetwork!.encryption,
            threatLevel: currentNetwork!.threatLevel,
            downloadSpeed: downloadSpeed,
            uploadSpeed: uploadSpeed,
            ping: currentNetwork!.ping,
          );

          isSpeedTestRunning = false;
          notifyListeners();

          if (kDebugMode) {
            print("Download: $downloadSpeed Mbps");
            print("Upload: $uploadSpeed Mbps");
          }
        },

        onError: (errorMessage, speedTestError) {
          isSpeedTestRunning = false;
          notifyListeners();

          if (kDebugMode) {
            print("Speed test error: $errorMessage");
          }
        },
      );
    } catch (e) {
      isSpeedTestRunning = false;
      notifyListeners();

      if (kDebugMode) {
        print("Speed test exception: $e");
      }
    }
  }

  /// Simulate download speed
  Future<double> _simulateDownloadSpeed() async {
    await Future.delayed(const Duration(seconds: 2));
    return 25 + (50 * Random().nextDouble()); // 25–75 Mbps
  }

  /// Simulate upload speed
  Future<double> _simulateUploadSpeed() async {
    await Future.delayed(const Duration(seconds: 1));
    return 10 + (20 * Random().nextDouble()); // 10–30 Mbps
  }

  /// Simulate ping in ms
  Future<int> _simulatePing() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 15 + Random().nextInt(50); // 15–65 ms
  }

  /// Basic threat analysis
  String _analyzeThreat(String ssid, String encryption) {
    if (encryption.toLowerCase().contains("open")) return "High";
    if (encryption.toLowerCase().contains("wpa3")) return "Low";
    return "Medium";
  }
}
