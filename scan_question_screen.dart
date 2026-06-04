import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;

class ScanQuestionScreen extends StatefulWidget {
  const ScanQuestionScreen({super.key});

  @override
  State<ScanQuestionScreen> createState() => _ScanQuestionScreenState();
}

class _ScanQuestionScreenState extends State<ScanQuestionScreen> {
  File? imageFile;
  String extractedText = "";
  String answer = "";
  bool loading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      imageFile = File(picked.path);
      setState(() {});
      await recognizeText();
    }
  }

  Future<void> recognizeText() async {
    final inputImage = InputImage.fromFile(imageFile!);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);

    extractedText = recognizedText.text;
    textRecognizer.close();

    await getAnswerFromAI();
  }

  Future<void> getAnswerFromAI() async {
    setState(() {
      loading = true;
    });

    const apiKey = "YOUR_OPENAI_API_KEY"; 

    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey"
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {"role": "user", "content": "Solve this question: $extractedText"}
        ]
      }),
    );

    final data = jsonDecode(response.body);
    answer = data["choices"][0]["message"]["content"];

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Question")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Open Camera"),
            ),
            const SizedBox(height: 20),
            if (loading) const CircularProgressIndicator(),
            if (answer.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    answer,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
