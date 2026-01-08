enum QrType { url, wifi, phone, sms, email, payment, text, unknown }

QrType detectQrType(String data) {
  if (data.startsWith('http://') || data.startsWith('https://')) {
    return QrType.url;
  }
  if (data.startsWith('WIFI:')) {
    return QrType.wifi;
  }
  if (data.startsWith('tel:')) {
    return QrType.phone;
  }
  if (data.startsWith('SMSTO:')) {
    return QrType.sms;
  }
  if (data.startsWith('mailto:')) {
    return QrType.email;
  }
  if (data.startsWith('000201')) {
    return QrType.payment; // bKash / Nagad / EMV
  }
  if (data.isNotEmpty) {
    return QrType.text;
  }
  return QrType.unknown;
}

Map<String, String> parseWifiQr(String data) {
  final Map<String, String> result = {};
  final parts = data.replaceFirst('WIFI:', '').split(';');

  for (final part in parts) {
    if (part.contains(':')) {
      final kv = part.split(':');
      result[kv[0]] = kv[1];
    }
  }
  return result;
}
