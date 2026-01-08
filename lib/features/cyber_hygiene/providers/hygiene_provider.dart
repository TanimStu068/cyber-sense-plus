import 'package:cyber_sense_plus/models/hygiene_model.dart';
import 'package:flutter/material.dart';

class HygieneProvider extends ChangeNotifier {
  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Tips
  final List<TipModel> _tips = [];
  List<TipModel> get tips => List.unmodifiable(_tips);

  // Quizzes
  final List<QuizModel> _quizzes = [];
  List<QuizModel> get quizzes => List.unmodifiable(_quizzes);

  // Badges
  final List<BadgeModel> _badges = [];
  List<BadgeModel> get badges => List.unmodifiable(_badges);

  // Fetch Tips (Simulated)
  Future<void> fetchTips() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _tips.clear();
    _tips.addAll([
      TipModel(
        id: '1',
        title: 'Use Strong Passwords',
        description:
            'Always use long, unique passwords that combine letters, numbers, and symbols. Avoid reusing passwords across accounts.',
        category: 'Passwords',
        source: 'NIST Guidelines',
        icon: Icons.lock,
        lastUpdated: DateTime(2025, 1, 1),
        isImportant: true,
      ),
      TipModel(
        id: '2',
        title: 'Enable Two-Factor Authentication (2FA)',
        description:
            '2FA adds an extra layer of security. Use authenticator apps or hardware tokens instead of SMS when possible.',
        category: 'Authentication',
        source: 'Cybersecurity Best Practices',
        icon: Icons.phonelink_lock,
        lastUpdated: DateTime(2025, 2, 15),
        isImportant: true,
      ),
      TipModel(
        id: '3',
        title: 'Keep Software Up-to-Date',
        description:
            'Regularly update your operating system, apps, and firmware to patch vulnerabilities and prevent exploits.',
        category: 'Software Security',
        source: 'Vendor Security Updates',
        icon: Icons.update,
        lastUpdated: DateTime(2025, 3, 10),
        isImportant: false,
      ),
      TipModel(
        id: '4',
        title: 'Use a VPN on Public Wi-Fi',
        description:
            'Encrypt your internet connection when using public Wi-Fi to protect your sensitive data from attackers.',
        category: 'Network Security',
        source: 'Cyber Awareness Training',
        icon: Icons.wifi_lock,
        lastUpdated: DateTime(2025, 4, 5),
        isImportant: false,
      ),
      TipModel(
        id: '5',
        title: 'Beware of Phishing Emails',
        description:
            'Do not click on suspicious links or attachments. Always verify the sender’s identity before taking action.',
        category: 'Email Security',
        source: 'Anti-Phishing Working Group',
        icon: Icons.email,
        lastUpdated: DateTime(2025, 5, 12),
        isImportant: true,
      ),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  // Fetch Quizzes (Simulated)
  // Fetch Quizzes (Simulated with 10 fixed questions)
  Future<void> fetchQuizzes() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _quizzes.clear();
    _quizzes.addAll([
      QuizModel(
        id: '1',
        question: 'What is the most secure type of password?',
        options: ['123456', 'Password', 'Random String', 'qwerty'],
        correctAnswer: 'Random String',
      ),
      QuizModel(
        id: '2',
        question: 'What does 2FA stand for?',
        options: [
          'Two-Factor Authentication',
          'Two-Faced Authorization',
          'Too Fast Access',
          'None of these',
        ],
        correctAnswer: 'Two-Factor Authentication',
      ),
      QuizModel(
        id: '3',
        question: 'Why should you update software regularly?',
        options: [
          'To enjoy new features',
          'To fix security vulnerabilities',
          'To slow down your device',
          'For no reason',
        ],
        correctAnswer: 'To fix security vulnerabilities',
      ),
      QuizModel(
        id: '4',
        question: 'Which of these is a safe browsing practice?',
        options: [
          'Clicking every link in emails',
          'Using HTTPS websites',
          'Downloading unknown files',
          'Ignoring security warnings',
        ],
        correctAnswer: 'Using HTTPS websites',
      ),
      QuizModel(
        id: '5',
        question: 'What is phishing?',
        options: [
          'A type of fishing',
          'A social engineering attack',
          'A firewall protocol',
          'A password manager',
        ],
        correctAnswer: 'A social engineering attack',
      ),
      QuizModel(
        id: '6',
        question: 'Why should you avoid public Wi-Fi for sensitive tasks?',
        options: [
          'It is slow',
          'It can be insecure',
          'It drains battery',
          'No reason',
        ],
        correctAnswer: 'It can be insecure',
      ),
      QuizModel(
        id: '7',
        question: 'What is a VPN used for?',
        options: [
          'Faster internet',
          'Encrypting your connection',
          'Blocking ads only',
          'Storing passwords',
        ],
        correctAnswer: 'Encrypting your connection',
      ),
      QuizModel(
        id: '8',
        question: 'Why is it important to log out from shared devices?',
        options: [
          'To save battery',
          'To prevent unauthorized access',
          'It is not important',
          'To free storage',
        ],
        correctAnswer: 'To prevent unauthorized access',
      ),
      QuizModel(
        id: '9',
        question: 'Which of these is a strong password?',
        options: [
          'password123',
          'MyName2024',
          r'Qf$8!vL@2p', // <-- raw string
          'abcdefg',
        ],
        correctAnswer: r'Qf$8!vL@2p', // <-- raw string
      ),

      QuizModel(
        id: '10',
        question: 'Why should you enable software auto-updates?',
        options: [
          'To get new features only',
          'To fix security vulnerabilities',
          'To slow down your system',
          'It is unnecessary',
        ],
        correctAnswer: 'To fix security vulnerabilities',
      ),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  // Fetch Badges (Simulated)
  Future<void> fetchBadges() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _badges.clear();
    _badges.addAll([
      BadgeModel(
        id: '1',
        name: 'Security Novice',
        description: 'Completed your first cyber hygiene tip.',
        icon: Icons.shield,
        category: 'Tips',
        level: 1,
        earnedDate: DateTime(2025, 1, 10),
        color: Colors.yellowAccent,
      ),
      BadgeModel(
        id: '2',
        name: 'Cyber Learner',
        description: 'Completed your first quiz.',
        icon: Icons.quiz,
        category: 'Quizzes',
        level: 1,
        earnedDate: DateTime(2025, 1, 15),
        color: Colors.cyanAccent,
      ),
      BadgeModel(
        id: '3',
        name: 'Cyber Pro',
        description: 'Earned 3 badges.',
        icon: Icons.emoji_events,
        category: 'Milestone',
        level: 2,
        earnedDate: DateTime(2025, 2, 1),
        color: Colors.orangeAccent,
      ),
      BadgeModel(
        id: '4',
        name: 'Phishing Expert',
        description: 'Answered 5 phishing-related quizzes correctly.',
        icon: Icons.phishing, // you can pick a close icon
        category: 'Quizzes',
        level: 2,
        earnedDate: DateTime(2025, 2, 5),
        isSpecial: true,
        color: Colors.redAccent,
      ),
      BadgeModel(
        id: '5',
        name: 'Password Master',
        description: 'Learned all password security tips.',
        icon: Icons.lock,
        category: 'Tips',
        level: 3,
        earnedDate: DateTime(2025, 2, 10),
        isSpecial: true,
        color: Colors.greenAccent,
      ),
      BadgeModel(
        id: '6',
        name: 'Cyber Champion',
        description: 'Completed all tips and quizzes.',
        icon: Icons.star,
        category: 'Milestone',
        level: 3,
        isSpecial: true,
        color: Colors.purpleAccent,
      ),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  // Optionally: Combined fetch for all
  Future<void> fetchAllData() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([fetchTips(), fetchQuizzes(), fetchBadges()]);

    _isLoading = false;
    notifyListeners();
  }
}
