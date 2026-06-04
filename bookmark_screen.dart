import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<String> bookmarkedQuestions = [];

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  void loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedQuestions =
          prefs.getStringList("bookmarked_questions") ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarked Questions"),
      ),
      body: bookmarkedQuestions.isEmpty
          ? const Center(child: Text("No Bookmarks Yet"))
          : ListView.builder(
        itemCount: bookmarkedQuestions.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                bookmarkedQuestions[index],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}