import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/AI%20Class/gemeni_api.dart';
import 'package:project_one/screens/app_screens/Widgets/appbar_custom.dart';
import 'package:project_one/screens/app_screens/Widgets/drawercustom.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'package:string_similarity/string_similarity.dart';
import 'package:flutter_html/flutter_html.dart';
class AiFeature extends StatefulWidget {
  const AiFeature({super.key});

  @override
  State<AiFeature> createState() => _AiFeatureState();
}

class _AiFeatureState extends State<AiFeature> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();
  String _responseText = '';
  bool _isLoading = false;

  String formatQuestions(String text) {
    // Split the text into lines
    List<String> lines = text.split('\n');
    List<String> questions = [];

    // Loop through each line
    for (var line in lines) {
      line = line.trim();

      if (line.startsWith("Explain") ||
          line.startsWith("Write") ||
          line.startsWith("What are") ||
          line.contains("?") ||
          line.contains(".")) {
        questions.add(line);
      } else if (line.isNotEmpty && questions.isNotEmpty) {
        questions.last += " $line";
      }
    }

    return questions.join('\n\n');
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _responseText = '';
    });

    String subject = _subjectController.text;
    String prompt = _promptController.text;
    String formattedQuestions = '';
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('QuestionPapers')
          .get();

      // Check for similar subject names
      var matchedDocs = querySnapshot.docs.where((doc) {
        String subjectName = doc['SubjectName'];
        return subjectName.similarityTo(subject) > 0.6; // Adjust the similarity threshold as needed
      }).toList();

      if (matchedDocs.isEmpty) {
        setState(() {
          _isLoading = false;
          _responseText = 'No similar subjects found.';
        });
        return;
      }

      for (var doc in matchedDocs) {
        String fileId = doc.id;

        Reference ref = FirebaseStorage.instance.ref().child('$fileId.pdf');
        String url = await ref.getDownloadURL();

        final response = await http.get(Uri.parse(url));
        final Uint8List bytes = response.bodyBytes;

        PdfDocument document = PdfDocument(inputBytes: bytes);

        String extractedText = PdfTextExtractor(document).extractText();
        formattedQuestions = formattedQuestions + formatQuestions(extractedText);
        document.dispose();
      }

final responses = await GeminiApi.generateText(
    "I have a set of questions extracted from a question paper, which may be poorly formatted due to the extraction process. Here are the questions: $formattedQuestions. I need help identifying the most repeated and important questions related to these topics: $prompt. These questions will be displayed in an app, so please provide the key questions organized by parts A abd B and also note that the response should be related to the topics");

      setState(() {
        _isLoading = false;
        _responseText = responses.text!;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _responseText = 'Error: $e';
      });
    }
  }

 @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Qp Bot",
      ),
      drawer: const DrawerCustom(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter Subject:', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the subject',
              ),
            ),
            const SizedBox(height: 20),
            const Text('Enter Topic:', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the topic',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit'),
              ),
            ),
            const SizedBox(height: 20),
            if (_responseText.isNotEmpty)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SingleChildScrollView(
                    child: Html(
                      data: _responseText.replaceAllMapped(
                        RegExp(r'\*\*(.*?)\*\*\##'), // Bold
                        (match) => '<b>${match[1]}</b>',
                      ).replaceAllMapped(
                        RegExp(r'\*(.*?)\*'), // Italics
                        (match) => '<i>${match[1]}</i>',
                      ).replaceAll('\n', '<br>'), // New lines
                      style: {
                        "body": Style(
                          fontSize: FontSize(16),
                          color: Colors.black87,
                        ),
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}