import 'dart:convert';
import 'package:http/http.dart' as http;

class PreferenceHelper
{
  static const String baseUrl = "http://localhost:5000";

  static Future<int> NotifChange(bool newNotif) async
  {
    final Map<String, dynamic> dataToSend = {
    'notifOn': newNotif,
    };

    final response = await http.put(Uri.parse("$baseUrl/profile/123/notifOn"),      //ERROR WOULD NEED SOME WAY TO GET CURRENT PROFILE ID 
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8', // Set content type
        },
        body: json.encode(dataToSend)
      );
    final data = jsonDecode(response.body);
    return data["value"];
  }
}