import 'dart:convert';
import 'package:google_maps_in_flutter/container_classes/profile.dart';
import 'package:http/http.dart' as http;
import '../container_classes/pin.dart';

class MapsHelper 
{
  static const String baseUrl = "http://10.0.2.2:5000";

  Future<void> addNewPin(Pin newPin) async
  {
    await http.post(Uri.parse("$baseUrl/pins/public"),      
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

  Future<void> addPrivatePin(Pin newPin) async
  {
    String email = CurProfile().email;

    await http.post(Uri.parse("$baseUrl/pins/private/$email"),      
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8', // Set content type
        },
        body: jsonEncode({
          'name': newPin.name,
          'description': newPin.description,
          'locationLat': newPin.latitude,
          'locationLong': newPin.longitude,
          'email' : email
        })
      );
  }
  
  static Future<List<Pin>> getPublicPins() async
  {
    List<Pin> dataToSend = []; 
    Pin tempPin;

    final response = await http.get(Uri.parse("$baseUrl/pins/public"), 
      );

    final data = jsonDecode(response.body);
    for(int i = 0; i < data["count"]; i++)//could break here
    {
      tempPin = new Pin.empty();
      tempPin.id = data["id" + i.toString()];
      tempPin.name = data["name" + i.toString()];
      tempPin.isPublic = true;
      tempPin.latitude = data["locationLat" + i.toString()];
      tempPin.longitude = data["locationLong" + i.toString()];
      tempPin.description = data["description" + i.toString()];
      
      dataToSend.add(tempPin);
      //print(tempPin.formatToPrint()); // knows we get here correctly
    }

    return dataToSend;
  }

  static Future<List<Pin>> getPrivatePins() async
  {
    List<Pin> dataToSend = []; 
    Pin tempPin;
    var email = CurProfile().email;

    final response = await http.get(Uri.parse("$baseUrl/pins/private/$email"), 
      );

    final data = jsonDecode(response.body);
    for(int i = 0; i < data["count"]; i++)//could break here
    {
      tempPin = new Pin.empty();
      tempPin.id = data["id" + i.toString()];
      tempPin.name = data["name" + i.toString()];
      tempPin.isPublic = false;
      tempPin.latitude = data["locationLat" + i.toString()];
      tempPin.longitude = data["locationLong" + i.toString()];
      tempPin.description = data["description" + i.toString()];
      
      dataToSend.add(tempPin);
      //print(tempPin.formatToPrint()); // knows we get here correctly
    }

    return dataToSend;
  }


  

}