import 'package:cyber_sense_plus/features/threat_news/models/threat_news_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/threat_news_provider.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  String selectedSeverity = "All";

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThreatNewsProvider>(context);

    // Apply severity filter
    List<ThreatNews> filteredNews = selectedSeverity == "All"
        ? provider.news
        : provider.news
              .where(
                (n) =>
                    n.severity.toLowerCase() == selectedSeverity.toLowerCase(),
              )
              .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2A),
        foregroundColor: Colors.greenAccent,
        centerTitle: true,
        elevation: 2,
        title: const Text(
          "Cyber Threat News",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.greenAccent,
        onRefresh: () async {
          await provider.fetchNews();
        },
        child: Column(
          children: [
            // ================= Filter Section =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    "Filter by severity: ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    dropdownColor: const Color(0xFF1E1E2A),
                    value: selectedSeverity,
                    items: ["All", "High", "Medium", "Low"]
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(
                              s,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSeverity = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white12, thickness: 1, height: 1),

            // ================= News List =================
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.greenAccent,
                      ),
                    )
                  : filteredNews.isEmpty
                  ? const Center(
                      child: Text(
                        "No news available",
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredNews.length,
                      itemBuilder: (context, index) {
                        final news = filteredNews[index];
                        return _newsTile(context, news);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _newsTile(BuildContext context, ThreatNews news) {
    // Severity color
    Color severityColor;
    switch (news.severity.toLowerCase()) {
      case 'high':
        severityColor = Colors.redAccent;
        break;
      case 'medium':
        severityColor = Colors.orangeAccent;
        break;
      default:
        severityColor = Colors.greenAccent;
    }

    return GestureDetector(
      onTap: () {
        _showNewsDetail(context, news);
      },
      child: Card(
        color: const Color(0xFF1E1E2A),
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Severity Tag
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  news.severity.toUpperCase(),
                  style: TextStyle(
                    color: severityColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                news.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),

              // Source & Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    news.source,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  Text(
                    _formatDate(news.date),
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNewsDetail(BuildContext context, ThreatNews news) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1E1E2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  news.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),

                // Source + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      news.source,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _formatDate(news.date),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  news.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Close",
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return "Today";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}
