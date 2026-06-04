import 'package:flutter/material.dart';
import '../data/notes_data.dart';
import 'notes_screen.dart';

class StudyMaterialScreen extends StatelessWidget {
  const StudyMaterialScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final subjects = notesData.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Subject Wise Notes"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: subjects.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NotesScreen(subjectName: subjects[index]),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  subjects[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
