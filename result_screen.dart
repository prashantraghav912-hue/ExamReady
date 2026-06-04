import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'quiz_screen.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final List<Map<String, dynamic>> reviewData;
  final String subject; //  Added subject

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.reviewData,
    required this.subject, //  Required subject
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;
  late double percentage;

  @override
  void initState() {
    super.initState();

    percentage =
    widget.total == 0 ? 0 : (widget.score / widget.total) * 100;

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    if (percentage >= 80) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String getMessage() {
    if (percentage >= 90) return "🏆 Excellent!";
    if (percentage >= 70) return "🔥 Great Job!";
    if (percentage >= 50) return "👍 Keep Practicing";
    return "📚 Study More";
  }

  Color getScoreColor() {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff4e73df), Color(0xff1cc88a)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 25,
              gravity: 0.15,
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                const SizedBox(height: 20),

                // Animated Score Text
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: widget.score),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) {
                    return Text(
                      "Score: $value / ${widget.total}",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 25),

                // Circular Progress
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: percentage / 100),
                        duration: const Duration(seconds: 2),
                        builder: (context, value, _) {
                          return CircularProgressIndicator(
                            value: value,
                            strokeWidth: 10,
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation(
                                getScoreColor()),
                          );
                        },
                      ),
                    ),
                    Text(
                      "${percentage.toInt()}%",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  getMessage(),
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Answer Review",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                // Review List
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.reviewData.length,
                    itemBuilder: (context, index) {
                      final data = widget.reviewData[index];
                      bool isCorrect =
                          data["userAnswer"] ==
                              data["correctAnswer"];

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(
                            isCorrect
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: isCorrect
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(data["question"]),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Answer: ${data["userAnswer"]}",
                                style: TextStyle(
                                  color: isCorrect
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              Text(
                                "Correct: ${data["correctAnswer"]}",
                                style: const TextStyle(
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // Buttons
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                QuizScreen(subject: widget.subject),
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.popUntil(
                            context,
                                (route) => route.isFirst);
                      },
                      icon: const Icon(Icons.home),
                      label: const Text("Home"),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
