import 'package:cyber_sense_plus/features/threat_news/screens/news_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/threat_news_model.dart';
import '../providers/threat_news_provider.dart';

class NewsDashboardSection extends StatelessWidget {
  const NewsDashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Don't listen here to avoid rebuild loop
    final provider = Provider.of<ThreatNewsProvider>(context, listen: false);

    // Fetch news after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.news.isEmpty && !provider.isLoading) {
        provider.fetchNews();
      }
    });

    return Consumer<ThreatNewsProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Cyber Threats",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => NewsFeedScreen()),
                      );
                    },
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewsFeedScreen(),
                          ),
                        );
                      },
                      child: const Text("See All"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Horizontal scrollable news cards
            SizedBox(
              height: 160,
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.greenAccent,
                      ),
                    )
                  : provider.news.isEmpty
                  ? const Center(
                      child: Text(
                        "No latest threats available",
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: provider.news.length > 5
                          ? 5
                          : provider.news.length, // show only 5 in dashboard
                      itemBuilder: (context, index) {
                        final news = provider.news[index];
                        return _newsCard(context, news);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _newsCard(BuildContext context, ThreatNews news) {
    // Severity color coding
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewsFeedScreen()),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade900.withOpacity(0.9),
              Colors.grey.shade800.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: severityColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: severityColor.withOpacity(0.6), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Severity Tag
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
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
              const SizedBox(height: 10),

              // News title
              Expanded(
                child: Text(
                  news.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Source & Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    news.source,
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                  Text(
                    _formatDate(news.date),
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
