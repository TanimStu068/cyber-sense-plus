import 'package:hive/hive.dart';

part 'incident_model.g.dart'; // <- This is required for Hive code generation

@HiveType(typeId: 2)
class Incident extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String category;

  @HiveField(3)
  String severity;

  @HiveField(4)
  String date;

  @HiveField(5)
  String notes;

  Incident({
    required this.id,
    required this.title,
    required this.category,
    required this.severity,
    required this.date,
    required this.notes,
  });

  Incident copyWith({
    String? id,
    String? title,
    String? category,
    String? severity,
    String? date,
    String? notes,
  }) {
    return Incident(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }
}
