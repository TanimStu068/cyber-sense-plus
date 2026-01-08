import 'dart:io';
import 'package:cyber_sense_plus/features/threat_news/screens/news_dashboard_section.dart';
import 'package:cyber_sense_plus/features/breach_monitor/screens/breach_monitor_screen.dart';
import 'package:cyber_sense_plus/features/cyber_hygiene/screens/cyber_hygiene_home_screen.dart';
import 'package:cyber_sense_plus/features/incident_logbook/screens/incident_list_screen.dart';
import 'package:cyber_sense_plus/features/network_safety/providers/network_provider.dart';
import 'package:cyber_sense_plus/features/network_safety/screens/network_home_screen.dart';
import 'package:cyber_sense_plus/features/password_vault/providers/password_provider.dart';
import 'package:cyber_sense_plus/features/password_vault/screens/password_list_screen.dart';
import 'package:cyber_sense_plus/features/profile/screens/profile_screen.dart';
import 'package:cyber_sense_plus/features/secure_notes/screens/notes_list_screen.dart';
import 'package:cyber_sense_plus/features/threat_scanner/screens/threat_scanner_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import 'package:cyber_sense_plus/features/dashboard/screens/quick_stats_card.dart';
import 'package:cyber_sense_plus/core/widgets/chart_widgets.dart';
import 'package:provider/provider.dart';
import 'package:cyber_sense_plus/features/incident_logbook/providers/incident_provider.dart';
import 'package:cyber_sense_plus/features/incident_logbook/screens/incident_detail_screen.dart';
import 'package:cyber_sense_plus/features/profile/providers/profile_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentProvider = context.watch<IncidentProvider>();
    final incidents = incidentProvider.incidents;
    final passwordProvider = context.watch<PasswordProvider>();
    final networkProvider = context.watch<NetworkProvider>();
    final network = networkProvider.currentNetwork;
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profile;

    int networkHealthScore = 0;

    if (network != null) {
      int signalScore = (network.signalLevel + 100).clamp(0, 100);
      int threatPenalty = network.threatLevel == "High"
          ? 40
          : network.threatLevel == "Medium"
          ? 20
          : 0;

      int speedScore =
          ((network.downloadSpeed /
                      networkProvider.getMaxSpeed(network.frequency)) *
                  100)
              .clamp(0, 100)
              .toInt();

      networkHealthScore =
          ((signalScore * 0.4) + (speedScore * 0.4) - threatPenalty)
              .clamp(0, 100)
              .toInt();
    }

    int threatsDetectedCount = incidents
        .where(
          (incident) =>
              incident.severity == "High" || incident.severity == "Medium",
        )
        .length;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header: User greeting + notifications
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back",
                          style: GoogleFonts.montserrat(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.name.isNotEmpty ? profile.name : "User",
                          style: GoogleFonts.montserrat(
                            color: AppColors.primaryAccent,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileScreen(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white12,
                            backgroundImage: profile.avatarPath != null
                                ? FileImage(File(profile.avatarPath!))
                                : null,
                            child: profile.avatarPath == null
                                ? Icon(
                                    Icons.person,
                                    color: AppColors.primaryAccent,
                                    size: 32,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.backgroundDark,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Quick Stats Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Security Stats",
                      style: GoogleFonts.montserrat(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            QuickStatsCard(
                              title: "Passwords Saved",
                              count: passwordProvider.passwords.length,
                              icon: Icons.lock,
                              gradientColors: [
                                Color(0xFF4CAF50),
                                Color(0xFF81C784),
                              ],
                            ),
                            const SizedBox(width: 4),
                            QuickStatsCard(
                              title: "Threats Detected",
                              count: threatsDetectedCount,
                              icon: Icons.warning,
                              gradientColors: threatsDetectedCount >= 10
                                  ? [Colors.redAccent, Colors.deepOrange]
                                  : threatsDetectedCount >= 5
                                  ? [Colors.orangeAccent, Colors.orange]
                                  : [Colors.greenAccent, Colors.green],
                            ),
                            const SizedBox(width: 4),
                            QuickStatsCard(
                              title: "Breaches Monitored",
                              count: 3,
                              icon: Icons.security,
                              gradientColors: [
                                Color(0xFF8E24AA),
                                Color(0xFFBA68C8),
                              ],
                            ),
                            const SizedBox(width: 4),
                            QuickStatsCard(
                              title: "Network Health",
                              count: network != null ? networkHealthScore : 0,
                              icon: Icons.network_check,
                              gradientColors: network == null
                                  ? [Colors.grey, Colors.grey.shade700]
                                  : networkHealthScore >= 80
                                  ? [Colors.greenAccent, Colors.green]
                                  : networkHealthScore >= 50
                                  ? [Colors.orangeAccent, Colors.orange]
                                  : [Colors.redAccent, Colors.red],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quick Actions Grid Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  "Quick Actions",
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Quick Actions Grid
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double spacing = 12;
                    int itemsPerRow = 3;
                    double totalSpacing = spacing * (itemsPerRow - 1);
                    double itemWidth =
                        (constraints.maxWidth - totalSpacing) / itemsPerRow;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        _featureCard(
                          context,
                          icon: Icons.lock,
                          title: "Password Vault",
                          color: Colors.cyanAccent,
                          destination: const PasswordListScreen(),
                          width: itemWidth,
                        ),
                        _featureCard(
                          context,
                          icon: Icons.note,
                          title: "Secure Notes",
                          color: Colors.greenAccent,
                          destination: const NotesListScreen(),
                          width: itemWidth,
                        ),
                        _featureCard(
                          context,
                          icon: Icons.qr_code_scanner,
                          title: "Threat Scanner",
                          color: Colors.orangeAccent,
                          destination: const ThreatScannerHomeScreen(),
                          width: itemWidth,
                        ),
                        _featureCard(
                          context,
                          icon: Icons.monitor_heart,
                          title: "Breach Monitor",
                          color: Colors.redAccent,
                          destination: const BreachMonitorScreen(),
                          width: itemWidth,
                        ),
                        _featureCard(
                          context,
                          icon: Icons.wifi,
                          title: "Network Safety",
                          color: Colors.purpleAccent,
                          destination: const NetworkHomeScreen(),
                          width: itemWidth,
                        ),
                        _featureCard(
                          context,
                          icon: Icons.badge,
                          title: "Cyber Hygiene",
                          color: Colors.teal,
                          destination: CyberHygieneHomeScreen(),
                          width: itemWidth,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // ================= Threat News Section =================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: NewsDashboardSection(),
              ),
            ),

            // Recent Incidents
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Incidents",
                          style: GoogleFonts.montserrat(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const IncidentListScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "View all",
                            style: GoogleFonts.montserrat(
                              color: AppColors.primaryAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    if (incidentProvider.isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Colors.greenAccent,
                        ),
                      )
                    else if (incidents.isEmpty)
                      const Text(
                        "No incidents recorded yet",
                        style: TextStyle(color: Colors.white54),
                      )
                    else
                      Column(
                        children: incidents
                            .take(3) // show latest 3
                            .map(
                              (incident) => Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: Colors.white12,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.warning,
                                    color: incident.severity == "High"
                                        ? Colors.redAccent
                                        : incident.severity == "Medium"
                                        ? Colors.orangeAccent
                                        : Colors.greenAccent,
                                  ),
                                  title: Text(
                                    incident.title,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Reported on ${incident.date}",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => IncidentDetailScreen(
                                          incidentId: incident.id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),

            // Cyber Hygiene Progress
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cyber Hygiene Progress",
                      style: GoogleFonts.montserrat(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.7,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryAccent,
                      ),
                      minHeight: 12,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "70% Completed",
                      style: GoogleFonts.montserrat(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Security Trend Chart
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.withOpacity(0.3),
                        Colors.blueAccent.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Security Score Trend",
                        style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(height: 180, child: ChartWidget()),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required Widget destination,
    double width = 105, // default width
    double height = 105, // optional height
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
      },
      child: SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
