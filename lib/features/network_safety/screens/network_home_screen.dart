import 'package:cyber_sense_plus/features/network_safety/screens/network_scanning_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import '../providers/network_provider.dart';
import 'network_detail_screen.dart';

class NetworkHomeScreen extends StatelessWidget {
  const NetworkHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,

      body: networkProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : networkProvider.currentNetwork == null
          ? Center(
              child: Text(
                "No network detected.",
                style: GoogleFonts.montserrat(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NetworkDetailScreen(
                        networkId: networkProvider.currentNetwork!.ssid,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor:
                          networkProvider.currentNetwork!.threatLevel == "High"
                          ? Colors.redAccent
                          : networkProvider.currentNetwork!.threatLevel ==
                                "Medium"
                          ? Colors.orangeAccent
                          : Colors.greenAccent,
                      child: const Icon(
                        Icons.wifi,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      networkProvider.currentNetwork!.ssid,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Threat Level: ${networkProvider.currentNetwork!.threatLevel}",
                          style: GoogleFonts.montserrat(
                            color:
                                networkProvider.currentNetwork!.threatLevel ==
                                    "High"
                                ? Colors.redAccent
                                : networkProvider.currentNetwork!.threatLevel ==
                                      "Medium"
                                ? Colors.orangeAccent
                                : Colors.greenAccent,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        networkProvider.isSpeedTestRunning
                            ? LinearProgressIndicator(
                                color: Colors.cyanAccent,
                                backgroundColor: Colors.white12,
                              )
                            : Text(
                                "Download: ${networkProvider.downloadSpeed.toStringAsFixed(1)} Mbps, Upload: ${networkProvider.uploadSpeed.toStringAsFixed(1)} Mbps",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.speed,
                        color: Colors.cyanAccent,
                        size: 35,
                      ),
                      onPressed: () async {
                        await networkProvider.runSpeedTest();
                      },
                    ),
                  ),
                ),
              ),
            ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔘 Scan Button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
              ),
              icon: const Icon(
                Icons.network_check,
                color: Colors.black,
                size: 25,
              ),
              label: Text(
                "Scan Network",
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NetworkScanningScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // 📝 Micro-copy text
          Text(
            "Tap to scan your current Wi-Fi",
            style: GoogleFonts.montserrat(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
