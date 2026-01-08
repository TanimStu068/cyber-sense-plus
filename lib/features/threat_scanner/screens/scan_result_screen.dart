import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import '../providers/scanner_provider.dart';

class ScanResultScreen extends StatelessWidget {
  final String url;
  final String result;

  const ScanResultScreen({super.key, required this.url, required this.result});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScannerProvider>(context, listen: false);
    final isSafe = result.contains("Safe");

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: Colors.cyanAccent,
        elevation: 0,
        title: Text(
          "Scan Result",
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSafe
                    ? Icons.check_circle_outline
                    : Icons.warning_amber_rounded,
                color: isSafe ? Colors.greenAccent : Colors.redAccent,
                size: 100,
              ),
              const SizedBox(height: 24),
              Text(
                url,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSafe
                        ? [
                            Colors.greenAccent.withOpacity(0.3),
                            Colors.greenAccent.withOpacity(0.1),
                          ]
                        : [
                            Colors.redAccent.withOpacity(0.3),
                            Colors.redAccent.withOpacity(0.1),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  result,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: isSafe ? Colors.greenAccent : Colors.redAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: isSafe && Uri.tryParse(url)?.hasAbsolutePath == true
                    ? () async {
                        await provider.launchUrlInBrowser(url);
                      }
                    : null,
                icon: const Icon(Icons.open_in_browser, color: Colors.black),
                label: Text(
                  "Open in Browser",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
