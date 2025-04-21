import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Fetching data from the API (Simulating messages)
  Future<List<Map<String, dynamic>>> fetchMessages() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load messages');
    }
  }
}
