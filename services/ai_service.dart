import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  final String apiKey;
  final String apiEndpoint;

  AiService({
    required this.apiKey,
    required this.apiEndpoint,
  });

  Future<String> generateResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(apiEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful Somali language tutor. Respond in both Somali and English.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.7,
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error communicating with AI service: $e');
    }
  }

  Future<String> evaluatePronunciation(String audioBase64) async {
    try {
      final response = await http.post(
        Uri.parse('$apiEndpoint/evaluate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'audio': audioBase64,
          'language': 'somali',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['feedback'];
      } else {
        throw Exception('Failed to evaluate pronunciation: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error evaluating pronunciation: $e');
    }
  }
}
