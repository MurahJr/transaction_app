import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:5000"; // Flask backend

  static Future<bool> addTransaction(String description, double amount) async {
    final response = await http.post(
      Uri.parse("$baseUrl/transactions"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "description": description,
        "amount": amount,
        "date": DateTime.now().toIso8601String().split('T')[0],
      }),
    );

    return response.statusCode == 201;
  }
}
