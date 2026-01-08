import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // fully dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2A),
        foregroundColor: Colors.cyanAccent,
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Privacy & Policy",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerCard(),
            const SizedBox(height: 24),
            _section(
              title: "1. Data Collection",
              content:
                  "Cyber Sense collects only essential information required "
                  "to provide secure and personalized cyber awareness features. "
                  "This may include account details, usage analytics, and "
                  "security-related logs.",
            ),
            _section(
              title: "2. Data Usage",
              content:
                  "All collected data is strictly used to improve threat "
                  "detection insights, enhance user experience, and maintain "
                  "system integrity. We do not sell or misuse user data.",
            ),
            _section(
              title: "3. Data Protection",
              content:
                  "We apply industry-standard security practices including "
                  "encryption, secure storage, and controlled access to "
                  "safeguard your information against unauthorized access.",
            ),
            _section(
              title: "4. Third-Party Services",
              content:
                  "Cyber Sense may integrate trusted third-party services "
                  "such as analytics or authentication providers. These "
                  "services comply with strict privacy and security standards.",
            ),
            _section(
              title: "5. User Control",
              content:
                  "You have full control over your account data. You may "
                  "update, export, or permanently delete your information "
                  "from the system at any time.",
            ),
            _section(
              title: "6. Policy Updates",
              content:
                  "This privacy policy may be updated periodically to reflect "
                  "security improvements or legal requirements. Users will be "
                  "notified of significant changes.",
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: const [
                  Icon(
                    Icons.shield_outlined,
                    size: 36,
                    color: Colors.greenAccent,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Your privacy is our responsibility.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====================== UI COMPONENTS ======================

  Widget _headerCard() {
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
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: Colors.greenAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Privacy First",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Cyber Sense is built with security, transparency, "
                      "and user trust at its core.",
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: Colors.greenAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
