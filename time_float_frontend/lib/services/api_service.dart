import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://localhost:8080/api';

class ApiService {
  final String? token;

  ApiService({this.token});

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> get(String path) async {
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    if (data['code'] != 200) {
      throw Exception(data['message'] ?? '请求失败');
    }
    return data;
  }
}
