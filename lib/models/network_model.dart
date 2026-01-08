class NetworkModel {
  final String id;
  final String ssid;
  final String bssid;
  final String encryption;
  final int signalStrength; // in dBm
  final int frequency; // in MHz
  DateTime lastScanned;
  String threatLevel; // Low, Medium, High

  NetworkModel({
    required this.id,
    required this.ssid,
    required this.bssid,
    required this.encryption,
    required this.signalStrength,
    required this.frequency,
    required this.lastScanned,
    required this.threatLevel,
  });

  // Optional: Convert to JSON (for storage or API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ssid': ssid,
      'bssid': bssid,
      'encryption': encryption,
      'signalStrength': signalStrength,
      'frequency': frequency,
      'lastScanned': lastScanned.toIso8601String(),
      'threatLevel': threatLevel,
    };
  }

  // Optional: Create from JSON
  factory NetworkModel.fromJson(Map<String, dynamic> json) {
    return NetworkModel(
      id: json['id'],
      ssid: json['ssid'],
      bssid: json['bssid'],
      encryption: json['encryption'],
      signalStrength: json['signalStrength'],
      frequency: json['frequency'],
      lastScanned: DateTime.parse(json['lastScanned']),
      threatLevel: json['threatLevel'],
    );
  }
}
