import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import '../providers/hygiene_provider.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  @override
  void initState() {
    super.initState();
    final hygieneProvider = Provider.of<HygieneProvider>(
      context,
      listen: false,
    );
    hygieneProvider.fetchBadges();
  }

  @override
  Widget build(BuildContext context) {
    final hygieneProvider = Provider.of<HygieneProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: Colors.cyanAccent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Your Badges",
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
      body: hygieneProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            )
          : hygieneProvider.badges.isEmpty
          ? Center(
              child: Text(
                "No badges earned yet.",
                style: GoogleFonts.montserrat(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: hygieneProvider.badges.length,
                itemBuilder: (context, index) {
                  final badge = hygieneProvider.badges[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildBadgeCard(context, badge),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildBadgeCard(BuildContext context, dynamic badge) {
    return Card(
      color: Colors.white12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: (badge.color ?? AppColors.primaryAccent)
                  .withOpacity(0.2),
              child: Icon(
                badge.icon ?? Icons.emoji_events,
                size: 30,
                color: badge.color ?? AppColors.primaryAccent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    badge.name,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    badge.description,
                    style: GoogleFonts.montserrat(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Category: ${badge.category} • Level: ${badge.level}',
                    style: GoogleFonts.montserrat(
                      color: Colors.cyanAccent,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Earned: ${badge.earnedDate != null ? "${badge.earnedDate!.day}/${badge.earnedDate!.month}/${badge.earnedDate!.year}" : "N/A"}',
                    style: GoogleFonts.montserrat(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  if (badge.isSpecial ?? false)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '🌟 Special Badge',
                        style: GoogleFonts.montserrat(
                          color: Colors.orangeAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
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
}
