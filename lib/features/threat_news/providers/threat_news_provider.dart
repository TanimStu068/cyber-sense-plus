import 'package:cyber_sense_plus/features/threat_news/models/threat_news_model.dart';
import 'package:cyber_sense_plus/features/threat_news/services/threat_news_service.dart';
import 'package:flutter/material.dart';

class ThreatNewsProvider with ChangeNotifier {
  List<ThreatNews> _news = [];
  bool _isLoading = false;

  List<ThreatNews> get news => _news;
  bool get isLoading => _isLoading;

  final ThreatNewsService _service = ThreatNewsService();

  String? errorMessage;

  Future<void> fetchNews() async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _news = await _service.getLatestNews();
    } catch (e) {
      print("Error fetching news: $e");
      _news = [];
      errorMessage = "Failed to fetch news";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
