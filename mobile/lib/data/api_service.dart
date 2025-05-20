import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    print('getUsers: $response');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<dynamic>> getBarang() async {
    final response = await http.get(Uri.parse('$baseUrl/barang'));
    print('getBarang: $response');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load barang');
    }
  }

  Future<List<dynamic>> getHistory({String? status}) async {
    String url = '$baseUrl/history';
    if (status != null && status != 'Semua') {
      url += '?status=$status';
    }

    final response = await http.get(Uri.parse(url));
    print('getHistory: $response');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load history');
    }
  }

  Future<dynamic> createHistory(Map<String, dynamic> historyData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/history'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(historyData),
    );
    print('createHistory: $response');
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create history');
    }
  }

  Future<dynamic> updateHistory(String id, Map<String, dynamic> updateData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/history/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateData),
    );
    print('updateHistory: $response');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update history');
    }
  }
}

