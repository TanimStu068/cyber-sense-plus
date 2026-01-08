import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cyber_sense_plus/core/contants/colors.dart';
import '../providers/hygiene_provider.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

// class QuizzesScreen extends StatelessWidget {
class _QuizzesScreenState extends State<QuizzesScreen> {
  @override
  void initState() {
    super.initState();
    final hygieneProvider = Provider.of<HygieneProvider>(
      context,
      listen: false,
    );
    hygieneProvider.fetchQuizzes(); // Fetch quizzes when screen opens
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
          "Cyber Hygiene Quizzes",
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
              itemCount: hygieneProvider.quizzes.length,
              itemBuilder: (context, index) {
                final quiz = hygieneProvider.quizzes[index];
                return GestureDetector(
                  onTap: () => _showQuizDialog(context, quiz),
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
                        quiz.question,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.cyanAccent,
                        size: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showQuizDialog(BuildContext context, dynamic quiz) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.backgroundDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Quiz Question",
          style: GoogleFonts.montserrat(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              quiz.question,
              style: GoogleFonts.montserrat(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(quiz.options.length, (i) {
              final option = quiz.options[i];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    final isCorrect = option == quiz.correctAnswer;

                    // final isCorrect = option == quiz.answer;
                    Navigator.pop(context);
                    _showResultDialog(context, isCorrect);
                  },
                  child: Text(
                    option,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context, bool isCorrect) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.backgroundDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isCorrect ? "Correct!" : "Oops!",
          style: GoogleFonts.montserrat(
            color: isCorrect ? Colors.greenAccent : Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Text(
          isCorrect
              ? "You chose the right answer."
              : "That's not correct. Try another one!",
          style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: GoogleFonts.montserrat(color: Colors.cyanAccent),
            ),
          ),
        ],
      ),
    );
  }
}
