class BreachModel {
  final String id;
  final String title;
  final String description;
  final String severity; // e.g., Low, Medium, High, Critical
  final DateTime date;
  final List<String> affectedAccounts;

  BreachModel({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.date,
    required this.affectedAccounts,
  });

  // Optional: For converting from JSON (e.g., API or local storage)
  factory BreachModel.fromJson(Map<String, dynamic> json) {
    return BreachModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      severity: json['severity'] as String,
      date: DateTime.parse(json['date'] as String),
      affectedAccounts: List<String>.from(json['affectedAccounts'] ?? []),
    );
  }

  // Optional: To JSON (e.g., for saving)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'severity': severity,
      'date': date.toIso8601String(),
      'affectedAccounts': affectedAccounts,
    };
  }
}
