import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'badges_screen.dart';
import 'tips_screen.dart';
import 'quizzes_screen.dart';

class CyberHygieneHomeScreen extends StatelessWidget {
  const CyberHygieneHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: Text("Cyber Hygiene"),
        backgroundColor: const Color(0xFF1F2233),
        foregroundColor: Colors.cyanAccent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _optionCard(
                context,
                icon: Icons.emoji_events,
                title: "Badges",
                subtitle: "Your achievements & rewards",
                color: Colors.yellowAccent,
                destination: const BadgesScreen(),
              ),
              const SizedBox(height: 16),
              _optionCard(
                context,
                icon: Icons.lightbulb,
                title: "Tips",
                subtitle: "Learn cyber hygiene best practices",
                color: Colors.cyanAccent,
                destination: const TipsScreen(),
              ),
              const SizedBox(height: 16),
              _optionCard(
                context,
                icon: Icons.quiz,
                title: "Quizzes",
                subtitle: "Test your security knowledge",
                color: Colors.orangeAccent,
                destination: const QuizzesScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget destination,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.6), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
