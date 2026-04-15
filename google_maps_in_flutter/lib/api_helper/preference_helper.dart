import 'dart:convert';
import 'package:http/http.dart' as http;

class PreferenceHelper {
  static const String baseUrl = 'http://10.0.2.2:5000';

  static Future<bool> getClubStatus(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/profile/$userId/isClub'));
    if (response.statusCode != 200) {
      return false;
    }

    final Map<String, dynamic> body = jsonDecode(response.body);
    return body['isClub'] == true;
  }

  static Future<void> updateNotif(String userId, bool newVal) async {
    await http.put(
      Uri.parse('$baseUrl/profile/$userId/notifOn'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'notifOn': newVal}),
    );
  }

  static Future<void> updateClub(String userId, bool newVal) async {
    await http.put(
      Uri.parse('$baseUrl/profile/$userId/isClub'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'isClub': newVal}),
    );
  }

  static Future<void> updateLocationPermission(String userId, bool newVal) async {
    await http.put(
      Uri.parse('$baseUrl/profile/$userId/locationPermission'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'locationPermission': newVal}),
    );
  }
}
