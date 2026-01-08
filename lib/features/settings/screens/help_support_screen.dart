import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
          "Help & Support",
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

            _supportTile(
              icon: Icons.security_outlined,
              title: "Security Assistance",
              subtitle:
                  "Report threats, vulnerabilities, or suspicious activity.",
              onTap: () => _showSnack(context, "Security support coming soon"),
            ),

            _supportTile(
              icon: Icons.question_answer_outlined,
              title: "Frequently Asked Questions",
              subtitle: "Quick answers to common security & app questions.",
              onTap: () => _showSnack(context, "FAQ module coming soon"),
            ),

            _supportTile(
              icon: Icons.bug_report_outlined,
              title: "Report a Bug",
              subtitle: "Help us improve Cyber Sense by reporting issues.",
              onTap: () => _showSnack(context, "Bug reporting coming soon"),
            ),

            _supportTile(
              icon: Icons.email_outlined,
              title: "Contact Support",
              subtitle: "Reach out to our cyber security support team.",
              onTap: () =>
                  _showSnack(context, "Email support integration pending"),
            ),

            const SizedBox(height: 32),

            _footer(),
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
                  Icons.support_agent,
                  color: Colors.greenAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Need Help?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Cyber Sense support is here to protect, guide, "
                      "and assist you anytime.",
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

  Widget _supportTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.greenAccent.withOpacity(0.12),
          ),
          child: Icon(icon, color: Colors.greenAccent),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.white70),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.white38,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _footer() {
    return Center(
      child: Column(
        children: const [
          Icon(Icons.shield_outlined, size: 36, color: Colors.greenAccent),
          SizedBox(height: 12),
          Text(
            "Security is not optional. We're here to help.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              letterSpacing: 0.4,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E1E2A),
      ),
    );
  }
}
