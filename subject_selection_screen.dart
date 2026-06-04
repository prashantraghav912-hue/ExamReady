import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class SubjectSelectionScreen extends StatelessWidget {
  const SubjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Subject"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            subjectButton(context, "Math"),
            subjectButton(context, "Science"),
            subjectButton(context, "English"),
            subjectButton(context, "History"),

          ],
        ),
      ),
    );
  }

  Widget subjectButton(BuildContext context, String subject) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuizScreen(subject: subject),
            ),
          );
        },
        child: Text(subject),
      ),
    );
  }
}