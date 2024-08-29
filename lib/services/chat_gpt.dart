import 'dart:convert';

import 'package:gardener/constants/tokens.dart';
import 'package:http/http.dart' as http;

class ChatGptServices {
  Future<String> findCompanions(
      List<String> plantsNames, List<String>? previousAnswers) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Authorization': 'Bearer $GPT_TOKEN',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'model': 'gpt-3.5-turbo', // You can adjust the model version as needed
      'messages': [
        {
          'role': 'system',
          'content':
              "You are a gardening specialist. You ought to answer your clients questions about companion planting. Check if client decided to plant plants which coexist okay with each other, if not inform they about it and suggest some changes. If the plants selected by the client coexist well then inform the client about it and suggest some other plants that could be planted with the plants selected by the client. ALL OF THE SUGGESTED PLANTS SHOULD BE COMPATIBLE WITH EACH PLANT PROVIDED BY CLIENT."
        },
        {
          'role': 'user',
          'content':
              "I want to find companions plants that I could plant together with: ${plantsNames}."
        }
      ],
      'max_tokens': 350,
    });

    final response = await http.post(url, headers: headers, body: body);
    Map<String, dynamic>? gptResponse;
    if (response.statusCode == 200) {
      gptResponse = jsonDecode(response.body) as Map<String, dynamic>;
      print(gptResponse);
      return gptResponse["choices"][0]["message"]["content"]!.toString();
    } else {
      print("Failed");
      return "";
    }
    print(gptResponse.toString());
  }
}
