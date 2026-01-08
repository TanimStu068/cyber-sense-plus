import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import '../providers/hygiene_provider.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

// class TipsScreen extends State {
class _TipsScreenState extends State<TipsScreen> {
  @override
  void initState() {
    super.initState();
    final hygieneProvider = Provider.of<HygieneProvider>(
      context,
      listen: false,
    );
    hygieneProvider.fetchTips();
  }

  @override
  Widget build(BuildContext context) {
    final hygieneProvider = Provider.of<HygieneProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Cyber Hygiene Tips",
          style: GoogleFonts.montserrat(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: hygieneProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hygieneProvider.tips.length,
              itemBuilder: (context, index) {
                final tip = hygieneProvider.tips[index];
                return Card(
                  color: Colors.white12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.primaryAccent,
                      child: Text(
                        "${index + 1}",
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      tip.title,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tip.description,
                            style: GoogleFonts.montserrat(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Category: ${tip.category}',
                            style: GoogleFonts.montserrat(
                              color: Colors.cyanAccent,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Source: ${tip.source}',
                            style: GoogleFonts.montserrat(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Last Updated: ${tip.lastUpdated != null ? "${tip.lastUpdated!.day}/${tip.lastUpdated!.month}/${tip.lastUpdated!.year}" : "N/A"}',
                            style: GoogleFonts.montserrat(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                          if (tip.isImportant)
                            Text(
                              'Important',
                              style: GoogleFonts.montserrat(
                                color: Colors.redAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: AppColors.primaryAccent,
                      child: Icon(tip.icon, color: Colors.black),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
