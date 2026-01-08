import 'package:cyber_sense_plus/features/onboarding/screens/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import 'package:cyber_sense_plus/core/widgets/custom_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToIntro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const IntroScreens()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 95),

                // App Logo / Icon
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryAccent.withOpacity(0.8),
                        AppColors.secondaryAccent.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 40),

                // App Name
                Text(
                  "CyberSense",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryAccent,
                    shadows: [
                      Shadow(
                        color: AppColors.primaryAccent.withOpacity(0.6),
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Tagline
                Text(
                  "Your Smart Digital Safety Companion",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondaryDark,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 80),

                // Start Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: CustomButton(
                    text: "Get Started",
                    onPressed: _goToIntro,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryAccent,
                        AppColors.secondaryAccent,
                      ],
                    ),
                    height: 55,
                    borderRadius: 16,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Footer text
                Text(
                  "Learn, Monitor & Protect",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
