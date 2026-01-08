import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import '../providers/network_provider.dart';

class NetworkDetailScreen extends StatelessWidget {
  final String networkId;

  const NetworkDetailScreen({super.key, required this.networkId});

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    final network = networkProvider.currentNetwork;

    if (network == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundDark,
          elevation: 0,
          title: Text(
            "Network Details",
            style: GoogleFonts.montserrat(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: Colors.cyanAccent,
        elevation: 0,
        title: Text(
          "Network Details",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Signal Strength Card
          _infoCard(
            title: "Signal Strength",
            icon: Icons.signal_wifi_4_bar,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${network.signalLevel} dBm",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: network.signalLevel.abs() / 100,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation(AppColors.primaryAccent),
                  minHeight: 10,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Encryption & Security Card
          _infoCard(
            title: "Encryption & Security",
            icon: Icons.security,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Encryption: ${network.encryption}",
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Threat Level: ${network.threatLevel}",
                  style: GoogleFonts.montserrat(
                    color: network.threatLevel == "High"
                        ? Colors.redAccent
                        : network.threatLevel == "Medium"
                        ? Colors.orangeAccent
                        : Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // IP & Gateway Card
          _infoCard(
            title: "IP & Gateway",
            icon: Icons.router,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "IP Address: ${network.ip}",
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Gateway: ${network.gateway}",
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Speed Test Card
          _infoCard(
            title: "Speed Test",
            icon: Icons.speed,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Download: ${network.downloadSpeed} Mbps",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value:
                      network.downloadSpeed /
                      networkProvider.getMaxSpeed(network.frequency),
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation(AppColors.secondaryAccent),
                  minHeight: 10,
                ),
                const SizedBox(height: 12),
                Text(
                  "Upload: ${network.uploadSpeed} Mbps",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value:
                      network.uploadSpeed /
                      networkProvider.getMaxSpeed(network.frequency),
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation(AppColors.primaryAccent),
                  minHeight: 10,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Latency Card
          _infoCard(
            title: "Latency / Ping",
            icon: Icons.network_ping,
            child: Text(
              "${network.ping} ms",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      color: Colors.white12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryAccent),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: Colors.cyanAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
