import 'package:capstone_proj/functions/generative_model.dart'; // Replace with your actual Gemini AI integration

class GeminiService {
  // Function to generate a response using Gemini AI
  Future<String> generateResponse(String input) async {
    try {
      // Call the Gemini AI API or function
      final response = await geminiGenerate(input); // Replace with your Gemini AI function
      return response;
    } catch (e) {
      print("Error generating AI response: $e");
      return "Sorry, I couldn't generate a response. Please try again.";
    }
  }
}