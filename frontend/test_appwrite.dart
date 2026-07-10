import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  final url = Uri.parse('https://156.67.26.89/v1/account');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'X-Appwrite-Project': '6a4f84e0002c6f50e59a',
    },
    body: jsonEncode({
      'userId': 'dart_test_123',
      'email': 'dart_test_999@gmail.com',
      'password': 'password123',
      'name': 'Dart Test',
    }),
  );

  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');
}
