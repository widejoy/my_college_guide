import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/Widgets/appbar_custom.dart';
import 'package:project_one/screens/app_screens/Widgets/drawercustom.dart';

class AiFeature extends StatefulWidget {
  const AiFeature({super.key});

  @override
  State<AiFeature> createState() => _AiFeatureState();
}

class _AiFeatureState extends State<AiFeature> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();

  void _submit() {
    String subject = _subjectController.text;
    String prompt = _promptController.text;
    // Add your logic to handle the subject and prompt here
    print('Subject: $subject');
    print('Prompt: $prompt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'QP BOT',
      ),
      drawer: const DrawerCustom(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Subject:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the subject',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter Prompt:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the prompt',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
