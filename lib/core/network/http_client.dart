import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClient {
  final http.Client _client = http.Client();
  
  Future<HttpResponse> get(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));
      return HttpResponse(
        data: json.decode(response.body),
        statusCode: response.statusCode,
      );
    } catch (e) {
      throw Exception('Falha na requisição HTTP: $e');
    }
  }
  
  void dispose() {
    _client.close();
  }
}

class HttpResponse {
  final dynamic data;
  final int statusCode;
  
  HttpResponse({required this.data, required this.statusCode});
}