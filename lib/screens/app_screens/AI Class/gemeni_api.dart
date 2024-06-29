import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiApi {
  static Future<GenerateContentResponse> generateText(String prompt) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: 'AIzaSyDX6h5RgkJEf5M3MbKCx5NVd1wAxBSRkkc',
    );

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response;
  }
}
