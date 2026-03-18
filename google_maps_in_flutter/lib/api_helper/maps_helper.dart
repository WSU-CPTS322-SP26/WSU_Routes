import 'dart:convert';
import 'package:http/http.dart' as http;
import '../controllers/map_controller.dart';
import '../container_classes/pin.dart';

class MapsHelper 
{
  static const String baseUrl = "http://10.0.2.2:5000";

  Future<void> AddNewPin(Pin newPin) async
  {
    final response = await http.post(Uri.parse("$baseUrl/pins/public"),      //ERROR WOULD NEED SOME WAY TO GET CURRENT PROFILE ID 
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8', // Set content type
        },
        body: jsonEncode({
          'name': newPin.name,
          'isPublic': newPin.isPublic,
          'description': newPin.description,
          'locationLat': newPin.latitude,
          'locationLong': newPin.longitude
        })
      );
  }

}