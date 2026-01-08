import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // fully dark
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2A),
        foregroundColor: Colors.cyanAccent,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          "About Cyber Sense",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _appIdentityCard(),
            const SizedBox(height: 24),
            _aboutSection(),
            const SizedBox(height: 24),
            _featureSection(),
            const SizedBox(height: 24),
            _techStackSection(),
            const SizedBox(height: 32),
            _footer(),
          ],
        ),
      ),
    );
  }

  // ===================== UI COMPONENTS =====================

  Widget _appIdentityCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F0F18), Color(0xFF1C1C2A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.shield,
                  size: 48,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Cyber Sense",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Security Intelligence Companion",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Version 1.0.0",
                style: TextStyle(fontSize: 12, color: Colors.white38),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _aboutSection() {
    return _sectionCard(
      title: "What is Cyber Sense?",
      icon: Icons.info_outline,
      content:
          "Cyber Sense is a modern cyber-security companion designed to help "
          "users stay informed, protected, and proactive against digital threats. "
          "It focuses on incident awareness, security insights, and best practices "
          "for a safer digital life.",
    );
  }

  Widget _featureSection() {
    return _sectionCard(
      title: "Key Capabilities",
      icon: Icons.security,
      content:
          "• Incident logging & monitoring\n"
          "• Security awareness tools\n"
          "• User-centric cyber insights\n"
          "• Privacy-focused architecture\n"
          "• Scalable for enterprise-grade security",
    );
  }

  Widget _techStackSection() {
    return _sectionCard(
      title: "Technology Stack",
      icon: Icons.code,
      content:
          "• Flutter (Cross-platform UI)\n"
          "• Provider (State Management)\n"
          "• Secure-first architecture\n"
          "• Cloud-ready for future integrations",
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1C1C2A), Color(0xFF24243C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.greenAccent),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.6,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footer() {
    return Column(
      children: const [
        Divider(color: Colors.white24),
        SizedBox(height: 12),
        Text(
          "© 2025 Cyber Sense",
          style: TextStyle(fontSize: 12, color: Colors.white38),
        ),
        SizedBox(height: 4),
        Text(
          "Built with security, trust & performance in mind",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 0.3,
            color: Colors.white24,
          ),
        ),
      ],
    );
  }
}
