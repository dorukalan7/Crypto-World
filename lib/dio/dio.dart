import 'package:dio/dio.dart';

class DioService {
  final Dio _dio = Dio();

  DioService() {
    // Dio configuration
    _dio.options.baseUrl = 'https://jsonplaceholder.typicode.com';  // API base URL
    _dio.options.connectTimeout = Duration(seconds: 5);  // Timeout süreleri
    _dio.options.receiveTimeout = Duration(seconds: 5);

    // Interceptors: Custom logging and token handling
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add authentication token to the headers (simulated)
        options.headers['Authorization'] = 'Bearer some_auth_token';
        print('Request: ${options.method} ${options.path}');
        return handler.next(options); // Continue request
      },
      onResponse: (response, handler) {
        // Log the response
        print('Response: ${response.statusCode} ${response.data}');
        return handler.next(response); // Continue response
      },
      onError: (DioError e, handler) {
        // Handle errors
        print('Error: ${e.message}');
        return handler.next(e); // Continue error handling
      },
    ));
  }

  // Fetch posts data from API (Example)
  Future<List<dynamic>> fetchPosts() async {
    try {
      final response = await _dio.get('/posts');  // API endpoint to fetch posts

      if (response.statusCode == 200) {
        if (response.data != null) {
          return response.data;  // Return data if successful
        } else {
          print('No data available');
          return [];  // Return empty list if no data available
        }
      } else {
        print('Error: ${response.statusCode}');
        return [];  // Return empty list if error occurs
      }
    } catch (e) {
      print('Error occurred while fetching data: $e');
      return [];  // Return empty list on exception
    }
  }

  // Fetch users data (Example)
  Future<List<dynamic>> fetchUsers() async {
    try {
      final response = await _dio.get('/users');  // API endpoint to fetch users

      if (response.statusCode == 200) {
        if (response.data != null) {
          return response.data;  // Return data if successful
        } else {
          print('No data available');
          return [];  // Return empty list if no data available
        }
      } else {
        print('Error: ${response.statusCode}');
        return [];  // Return empty list if error occurs
      }
    } catch (e) {
      print('Error occurred while fetching data: $e');
      return [];  // Return empty list on exception
    }
  }

  // Fetch music data (or other data) from /music endpoint
  Future<List<dynamic>> fetchMusicData() async {
    try {
      final response = await _dio.get('/music');  // API endpoint to fetch music

      if (response.statusCode == 200) {
        if (response.data != null) {
          return response.data;  // Return data if successful
        } else {
          print('No data available');
          return [];  // Return empty list if no data available
        }
      } else {
        print('Error: ${response.statusCode}');
        return [];  // Return empty list if error occurs
      }
    } catch (e) {
      print('Error occurred while fetching data: $e');
      return [];  // Return empty list on exception
    }
  }
}
