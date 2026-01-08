import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import 'package:provider/provider.dart';
import '../providers/scanner_provider.dart';
import 'scan_result_screen.dart';

class UrlScannerScreen extends StatefulWidget {
  const UrlScannerScreen({super.key});

  @override
  State<UrlScannerScreen> createState() => _UrlScannerScreenState();
}

class _UrlScannerScreenState extends State<UrlScannerScreen> {
  final _urlController = TextEditingController();
  bool _isScanning = false;

  void _scanUrl(BuildContext context) async {
    String url = _urlController.text.trim();
    if (url.isEmpty) {
      _showSnackBar("Please enter a URL to scan.");
      return;
    }

    // Add default scheme if missing
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    setState(() {
      _isScanning = true;
    });

    final scannerProvider = Provider.of<ScannerProvider>(
      context,
      listen: false,
    );

    // Simulate scan delay
    await Future.delayed(const Duration(seconds: 2));

    final result = await scannerProvider.scanUrl(url);

    setState(() {
      _isScanning = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScanResultScreen(url: url, result: result),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryAccent,
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: Colors.cyanAccent,
        elevation: 0,
        title: Text(
          "URL Threat Scanner",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Instruction Text
            Text(
              "Enter a URL to check for security threats",
              style: GoogleFonts.montserrat(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // URL Input Field
            TextFormField(
              controller: _urlController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "https://example.com",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.link, color: Colors.cyanAccent),
              ),
            ),
            const SizedBox(height: 30),

            // Scan Button
            GestureDetector(
              onTap: _isScanning ? null : () => _scanUrl(context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: _isScanning
                      ? LinearGradient(colors: [Colors.white12, Colors.white24])
                      : const LinearGradient(
                          colors: [
                            AppColors.primaryAccent,
                            AppColors.secondaryAccent,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryAccent.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: _isScanning
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Scanning...",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          "Scan URL",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Recent Scans Section
            Expanded(
              child: Consumer<ScannerProvider>(
                builder: (context, provider, _) {
                  final recentScans = provider.recentScans.reversed.toList();
                  if (recentScans.isEmpty) {
                    return Center(
                      child: Text(
                        "No recent scans.",
                        style: GoogleFonts.montserrat(color: Colors.white54),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: recentScans.length,
                    itemBuilder: (context, index) {
                      final scan = recentScans[index];
                      return Card(
                        color: Colors.white12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          leading: const Icon(
                            Icons.link,
                            color: Colors.cyanAccent,
                          ),
                          title: Text(
                            scan.url,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            scan.result,
                            style: GoogleFonts.montserrat(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
