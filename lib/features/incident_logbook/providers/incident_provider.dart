import 'package:cyber_sense_plus/models/incident_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

class IncidentProvider extends ChangeNotifier {
  static const String _boxName = "incidentsBox";
  Box<Incident>? _incidentBox;
  bool _isLoading = true; // <-- add this
  bool get isLoading => _isLoading;

  List<Incident> get incidents => _incidentBox?.values.toList() ?? [];

  IncidentProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    _incidentBox = await Hive.openBox<Incident>(_boxName);
    _isLoading = false; // <-- finished loading
    notifyListeners();
  }

  Incident? getIncidentById(String id) {
    if (_incidentBox == null) return null;
    return _incidentBox!.get(id);
  }

  // Updated addIncident to accept named parameters
  Future<void> addIncident({
    required String title,
    required String category,
    required String severity,
    required String date,
    required String notes,
  }) async {
    if (_incidentBox == null) return;

    final incident = Incident(
      id: const Uuid().v4(),
      title: title,
      category: category,
      severity: severity,
      date: date,
      notes: notes,
    );

    await _incidentBox!.put(incident.id, incident); // key = id
    notifyListeners();
  }

  Future<void> updateIncident(String id, Incident updatedIncident) async {
    if (_incidentBox == null) return;

    if (_incidentBox!.containsKey(id)) {
      await _incidentBox!.put(id, updatedIncident);
      notifyListeners();
    }
  }

  Future<void> deleteIncident(String id) async {
    if (_incidentBox == null) return;

    await _incidentBox!.delete(id);
    notifyListeners();
  }

  List<Incident> searchByTitle(String query) {
    return incidents
        .where(
          (incident) =>
              incident.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  List<Incident> filterByCategory(String category) {
    return incidents
        .where(
          (incident) =>
              incident.category.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }
}
