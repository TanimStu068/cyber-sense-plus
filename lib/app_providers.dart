import 'package:cyber_sense_plus/features/threat_news/providers/threat_news_provider.dart';
import 'package:cyber_sense_plus/features/breach_monitor/providers/breach_provider.dart';
import 'package:cyber_sense_plus/features/cyber_hygiene/providers/hygiene_provider.dart';
import 'package:cyber_sense_plus/features/incident_logbook/providers/incident_provider.dart';
import 'package:cyber_sense_plus/features/network_safety/providers/network_provider.dart';
import 'package:cyber_sense_plus/features/password_vault/providers/password_provider.dart';
import 'package:cyber_sense_plus/features/profile/providers/profile_provider.dart';
import 'package:cyber_sense_plus/features/secure_notes/providers/notes_provider.dart';
import 'package:cyber_sense_plus/features/settings/providers/settings_provider.dart';
import 'package:cyber_sense_plus/features/threat_scanner/providers/scanner_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => BreachProvider()),
    ChangeNotifierProvider(create: (_) => HygieneProvider()),
    ChangeNotifierProvider(create: (_) => IncidentProvider()),
    ChangeNotifierProvider(create: (_) => NetworkProvider()),
    ChangeNotifierProvider(create: (_) => PasswordProvider()..init()),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ChangeNotifierProvider(create: (_) => NotesProvider()..init()),
    ChangeNotifierProvider(create: (_) => SettingsProvider()),
    ChangeNotifierProvider(create: (_) => ScannerProvider()),
    ChangeNotifierProvider(create: (_) => ThreatNewsProvider()),
  ];
}
