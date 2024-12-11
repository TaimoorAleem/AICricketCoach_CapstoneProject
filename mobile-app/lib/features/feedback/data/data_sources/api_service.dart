import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  /// Trains the ML model on the Flask server.
  Future<void> trainModel() async {
    final response = await http.get(Uri.parse('$baseUrl/train'));

    if (response.statusCode == 200) {
      print("Model trained successfully: ${response.body}");
    } else {
      throw Exception('Failed to train model: ${response.statusCode} - ${response.body}');
    }
  }

  /// Sends input data to the Flask server and fetches the prediction results.
  Future<Map<String, dynamic>> predictShot(Map<String, dynamic> inputData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(inputData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to predict shot: ${response.statusCode} - ${response.body}');
    }
  }
}
