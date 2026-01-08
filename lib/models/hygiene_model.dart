import 'package:flutter/material.dart';

class TipModel {
  final String id;
  final String title;
  final String description;
  final String category; // e.g., "Passwords", "Network", "Device Security"
  final String source; // optional: where this tip comes from, e.g., "NIST"
  final IconData icon; // to show visually
  final DateTime? lastUpdated; // optional, for credibility
  final bool isImportant; // flag for highlighting critical tips

  TipModel({
    required this.id,
    required this.title,
    required this.description,
    this.category = "General",
    this.source = "",
    this.icon = Icons.security,
    this.lastUpdated,
    this.isImportant = false,
  });
}

class QuizModel {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

class BadgeModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final String category; // e.g., "Quiz", "Tips", "Milestones"
  final int level; // badge difficulty or tier: 1, 2, 3...
  final DateTime? earnedDate; // when user earned it
  final bool isSpecial; // for rare or achievement badges
  final Color? color; // badge color to distinguish levels visually

  BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.category = "General",
    this.level = 1,
    this.earnedDate,
    this.isSpecial = false,
    this.color,
  });
}
