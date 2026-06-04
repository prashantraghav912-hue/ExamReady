import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'study_material_screen.dart';import 'bookmark_screen.dart';
import 'scan_question_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'subject_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ✅ Save PDF function
  Future<void> saveDataAsPDF(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("ExamReady App Data",
                  style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text("• Quiz Attempts: 10"),
              pw.Text("• Bookmarks: 5"),
              pw.Text("• Study Time: 3 Hours"),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("PDF Generated Successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text(
          "ExamReady Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: [

            dashboardButton(
              Icons.quiz,
              "Start Quiz",
              const Color(0xFF6C63FF),
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubjectSelectionScreen(),
                  ),
                );
              },
            ),

            dashboardButton(
              Icons.menu_book_rounded,
              "Study Material",
              const Color(0xFF00B894),
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudyMaterialScreen()),
                );
              },
            ),

            dashboardButton(
              Icons.document_scanner_outlined,
              "Scan Question",
              const Color(0xFFF39C12),
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanQuestionScreen()),
                );
              },
            ),

            dashboardButton(
              Icons.bar_chart,
              "Result",
              const Color(0xFFE84393),
                  () {},
            ),

            dashboardButton(
              Icons.bookmark,
              "Bookmarks",
              const Color(0xFF0984E3),
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookmarkScreen()),
                );
              },
            ),

            dashboardButton(
              Icons.picture_as_pdf,
              "Save My Data",
              const Color(0xFFFFC107),
                  () {
                saveDataAsPDF(context); // ✅ context available
              },
            ),

            dashboardButton(
              Icons.info_outline,
              "About App",
              const Color(0xFF00CEC9),
                  () {},
            ),

            dashboardButton(
              Icons.logout,
              "Logout",
              const Color(0xFF636E72),
                  () {
                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget dashboardButton(
      IconData icon,
      String title,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      splashColor: Colors.white24,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.45),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 44, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}