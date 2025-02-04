import 'package:http/http.dart' as http;

class ApiHandler {
  final String url = 'http://localhost:8080/';
  final client = http.Client();
  final Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  };
}
