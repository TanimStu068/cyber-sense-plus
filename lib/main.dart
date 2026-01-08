import 'package:cyber_sense_plus/app.dart';
import 'package:cyber_sense_plus/app_providers.dart';
import 'package:cyber_sense_plus/models/incident_model.dart';
import 'package:cyber_sense_plus/models/note_model.dart';
import 'package:cyber_sense_plus/models/password_model.dart';
import 'package:cyber_sense_plus/models/user_profile_hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(PasswordModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(NoteModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(IncidentAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(UserProfileHiveAdapter());
  }

  await Hive.openBox<PasswordModel>('passwords');
  await Hive.openBox<NoteModel>('notesBox');
  await Hive.openBox<Incident>('incidents');
  await Hive.openBox('profileBox');

  runApp(MultiProvider(providers: AppProviders.providers, child: const App()));
}
