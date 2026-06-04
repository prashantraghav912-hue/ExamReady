import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String subject;

  const QuizScreen({super.key, required this.subject});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool isBookmarked = false;
  int score = 0;
  int currentIndex = 0;
  int timeLeft = 30;

  Timer? timer;
  bool answered = false;
  String? selectedOption;

  List<Map<String, dynamic>> reviewDataList = [];

  // ================= QUESTIONS =================
  final List<Map<String, Object>> questions = [
    {
      "question": "Flutter kis language par based hai?",
      "options": ["Java", "Dart", "Python", "C++"],
      "answer": "Dart",
    },
    {
      "question": "India ki capital kya hai?",
      "options": ["Mumbai", "Delhi", "Kolkata", "Chennai"],
      "answer": "Delhi",
    },
    {
      "question": "2 + 2 = ?",
      "options": ["3", "4", "5", "6"],
      "answer": "4",
    },
  ];

  @override
  void initState() {
    super.initState();
    checkBookmark();
    startTimer();
  }

  // ================= BOOKMARK =================
  void checkBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> saved =
        prefs.getStringList("bookmarked_questions") ?? [];

    String currentQuestion =
    questions[currentIndex]["question"].toString();

    setState(() {
      isBookmarked = saved.contains(currentQuestion);
    });
  }

  void toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> saved =
        prefs.getStringList("bookmarked_questions") ?? [];

    String currentQuestion =
    questions[currentIndex]["question"].toString();

    if (saved.contains(currentQuestion)) {
      saved.remove(currentQuestion);
    } else {
      saved.add(currentQuestion);
    }

    await prefs.setStringList("bookmarked_questions", saved);

    checkBookmark();
  }

  // ================= TIMER =================
  void startTimer() {
    timeLeft = 30;
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;

      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        t.cancel();
        nextQuestion();
      }
    });
  }

  // ================= CHECK ANSWER =================
  void checkAnswer(String option) {
    if (answered) return;

    timer?.cancel();

    setState(() {
      selectedOption = option;
      answered = true;

      if (option == questions[currentIndex]["answer"]) {
        score++;
      }

      reviewDataList.add({
        "question": questions[currentIndex]["question"],
        "userAnswer": option,
        "correctAnswer": questions[currentIndex]["answer"],
      });
    });

    // Auto next after 1.5 sec
    Future.delayed(const Duration(seconds: 1), () {
      nextQuestion();
    });
  }

  // ================= NEXT QUESTION =================
  void nextQuestion() {
    timer?.cancel();

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null;
        answered = false;
      });

      checkBookmark();
      startTimer();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: score,
            total: questions.length,
            reviewData: reviewDataList,
            subject: widget.subject, // 👈 Important
          ),
        ),
      );
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    var currentQuestion = questions[currentIndex];
    double progress = (currentIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: Text("${widget.subject} Quiz"),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked
                  ? Icons.bookmark
                  : Icons.bookmark_border,
            ),
            onPressed: toggleBookmark,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
              ),
            ),

            const SizedBox(height: 20),

            // Timer Circle
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Text(
                "$timeLeft",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Question Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  currentQuestion["question"]
                  as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Options
            ...(currentQuestion["options"]
            as List<String>)
                .map((option) {
              Color buttonColor = Colors.blue;

              if (answered) {
                if (option ==
                    questions[currentIndex]
                    ["answer"]) {
                  buttonColor = Colors.green;
                } else if (option ==
                    selectedOption) {
                  buttonColor = Colors.red;
                }
              }

              return Padding(
                padding:
                const EdgeInsets.only(
                    bottom: 12),
                child: ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    buttonColor,
                    padding:
                    const EdgeInsets
                        .symmetric(
                        vertical:
                        14),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(12),
                    ),
                  ),
                  onPressed: () =>
                      checkAnswer(option),
                  child: Text(
                    option,
                    style:
                    const TextStyle(
                        fontSize: 16),
                  ),
                ),
              );
            }),

            const Spacer(),

            // Question Counter
            Text(
              "Question ${currentIndex + 1} of ${questions.length}",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}