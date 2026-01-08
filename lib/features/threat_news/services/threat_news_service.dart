import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/threat_news_model.dart';

class ThreatNewsService {
  static const String _apiKey = "3d6d198242024d5aa084a52d9ddd480f";

  final String apiUrl =
      "https://newsapi.org/v2/everything"
      "?q=cybersecurity OR malware OR data breach"
      "&language=en"
      "&sortBy=publishedAt"
      "&pageSize=50"
      "&apiKey=$_apiKey";

  Future<List<ThreatNews>> getLatestNews() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List articles = decoded['articles'];

      return articles.map((item) {
        return ThreatNews(
          title: item['title'] ?? "Untitled Threat",
          description:
              item['description'] ?? item['content'] ?? "No details available",
          source: item['source']?['name'] ?? "Unknown Source",
          link: item['url'] ?? "",
          date: DateTime.tryParse(item['publishedAt'] ?? "") ?? DateTime.now(),
          severity: _detectSeverity(
            item['title'] ?? "",
            item['description'] ?? "",
          ),
        );
      }).toList();
    } else {
      throw Exception("Failed to fetch cyber threat news");
    }
  }

  // 🔥 Simple severity detection logic
  String _detectSeverity(String title, String description) {
    final text = (title + description).toLowerCase();

    if (text.contains("critical") ||
        text.contains("ransomware") ||
        text.contains("zero-day")) {
      return "High";
    }

    if (text.contains("breach") ||
        text.contains("malware") ||
        text.contains("phishing")) {
      return "Medium";
    }

    return "Low";
  }
}
