import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = "https://jsonplaceholder.typicode.com/posts";

  // Fetch a list of posts, each being a map
  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Parse the JSON response into a list of maps
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
