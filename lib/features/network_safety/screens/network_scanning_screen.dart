import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import '../providers/network_provider.dart';
import 'network_detail_screen.dart';

class NetworkScanningScreen extends StatefulWidget {
  const NetworkScanningScreen({super.key});

  @override
  State<NetworkScanningScreen> createState() => _NetworkScanningScreenState();
}

class _NetworkScanningScreenState extends State<NetworkScanningScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  String progressText = "Initializing scan...";
  Timer? _progressTimer;
  int _progressStep = 0;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // ✅ run AFTER build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScan();
    });

    // _startScan();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startScan() async {
    final networkProvider = Provider.of<NetworkProvider>(
      context,
      listen: false,
    );

    _progressStep = 0;

    _progressTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      setState(() {
        _progressStep++;
        switch (_progressStep) {
          case 1:
            progressText = "Detecting Wi-Fi network...";
            break;
          case 2:
            progressText = "Analyzing signal strength...";
            break;
          case 3:
            progressText = "Checking encryption & security...";
            break;
          case 4:
            progressText = "Measuring download/upload speed...";
            break;
          case 5:
            progressText = "Calculating ping & latency...";
            break;
          case 6:
            progressText = "Finalizing results...";
            break;
        }
      });

      if (_progressStep >= 6) {
        timer.cancel();
      }
    });

    // 🔥 WAIT for real scan
    await networkProvider.scanNetwork();

    // 🔥 Navigate ONLY after scan finishes
    if (!mounted) return;

    if (networkProvider.currentNetwork != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => NetworkDetailScreen(
            networkId: networkProvider.currentNetwork!.ssid,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No network detected")));
      Navigator.pop(context);
    }
  }

  // Trigger actual network scan  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryAccent,
                        AppColors.secondaryAccent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryAccent.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: const Icon(Icons.wifi, size: 64, color: Colors.white),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                progressText,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: LinearProgressIndicator(
                  value: _progressStep / 6,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation(AppColors.primaryAccent),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
