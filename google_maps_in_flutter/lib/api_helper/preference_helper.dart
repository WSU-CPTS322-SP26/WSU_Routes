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

  static Future<int> ClubChange(bool newClub) async
  {
    final Map<String, dynamic> dataToSend = {
    'isClub': newClub,
    };

    final response = await http.put(Uri.parse("$baseUrl/profile/123/isClub"),      //ERROR WOULD NEED SOME WAY TO GET CURRENT PROFILE ID 
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8', // Set content type
        },
        body: json.encode(dataToSend)
      );
    final data = jsonDecode(response.body);
    return data["value"];
  }

  static Future<int> LocationPermissionChange(bool newLocationPermission) async
  {
    final Map<String, dynamic> dataToSend = {
    'locationPermission': newLocationPermission,
    };

    final response = await http.put(Uri.parse("$baseUrl/profile/123/locationPermission"),      //ERROR WOULD NEED SOME WAY TO GET CURRENT PROFILE ID 
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8', // Set content type
        },
        body: json.encode(dataToSend)
      );
    final data = jsonDecode(response.body);
    return data["value"];
  }

  static Future<bool> GetisNotif(String id) async
  {
    final response = await http.get(Uri.parse("$baseUrl/profile/$id/notifOn"),      //ERROR WOULD NEED SOME WAY TO GET CURRENT PROFILE ID 
      headers: {
          'Content-Type': 'application/json; charset=UTF-8', // Set content type
        },
      );
    final data = jsonDecode(response.body);
    return data["notifOn"];
  }

}
