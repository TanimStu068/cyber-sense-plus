import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import '../providers/breach_provider.dart';
import 'breach_detail_screen.dart';

class BreachMonitorScreen extends StatelessWidget {
  const BreachMonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final breachProvider = Provider.of<BreachProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: Colors.cyanAccent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Breach Monitor",
          style: GoogleFonts.montserrat(
            color: Colors.cyanAccent,
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
      body: breachProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : breachProvider.breaches.isEmpty
          ? Center(
              child: Text(
                "No breaches detected.",
                style: GoogleFonts.montserrat(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: breachProvider.breaches.length,
              itemBuilder: (context, index) {
                final breach = breachProvider.breaches[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BreachDetailScreen(breach: breach),
                      ),
                    );
                  },
                  child: Card(
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
                      leading: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.redAccent, Colors.orangeAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.security,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),

                      title: Text(
                        breach.title,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        breach.description.length > 60
                            ? '${breach.description.substring(0, 60)}...'
                            : breach.description,
                        style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white54,
                        size: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryAccent,
        child: const Icon(Icons.refresh, color: Colors.black),
        onPressed: () async {
          // Refresh breaches
          await breachProvider.fetchBreaches();
        },
      ),
    );
  }
}
