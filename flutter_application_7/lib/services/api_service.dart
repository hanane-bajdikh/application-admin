import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<dynamic>> fetchAdmins() async {
    final response = await http.get(Uri.parse('$baseUrl/admins'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec du chargement des administrateurs');
    }
  }
}
