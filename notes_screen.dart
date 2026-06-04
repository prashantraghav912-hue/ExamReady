import 'package:flutter/material.dart';
import '../data/notes_data.dart';
import 'note_detail_screen.dart';

class NotesScreen extends StatelessWidget {
  final String subjectName;

  const NotesScreen({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context) {

    final topics = notesData[subjectName]?.keys.toList() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("$subjectName Topics"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(topics[index]),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteDetailScreen(
                      subject: subjectName,
                      topic: topics[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
