import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiApi {
  static Future<GenerateContentResponse> generateText(String prompt) async {
    final apiKey = dotenv.env['GOOGLE_GENERATIVE_AI_API_KEY'];
    if (apiKey == null) {
      throw Exception('API key is not found in the environment variables.');
    }

    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response;
  }
}
