import 'package:flutter/material.dart';
import '../data/notes_data.dart';

class NoteDetailScreen extends StatelessWidget {
  final String subject;
  final String topic;

  const NoteDetailScreen({
    super.key,
    required this.subject,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {

    final content = notesData[subject]?[topic] ?? "No notes available.";

    return Scaffold(
      appBar: AppBar(
        title: Text(topic),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
