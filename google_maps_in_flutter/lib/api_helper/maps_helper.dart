import 'dart:convert';
import 'package:http/http.dart' as http;
import '../container_classes/pin.dart';

class MapsHelper 
{
  static const String baseUrl = "http://10.0.2.2:5000";

  Future<void> addNewPin(Pin newPin) async
  {
    await http.post(Uri.parse("$baseUrl/pins/public"),      //ERROR WOULD NEED SOME WAY TO GET CURRENT PROFILE ID 
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

}