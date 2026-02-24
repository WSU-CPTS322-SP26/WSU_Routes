import 'dart:convert';
import 'package:http/http.dart' as http;
import '../container_classes/event.dart';

class EventsHelper 
{
  static const String baseUrl = "http://localhost:5000";

  static Future<List<Event>> GetPublicEvents() async
  {
    final List<Event> dataToSend = [];
    Event tempEvent;

    final response = await http.get(Uri.parse("$baseUrl/events/public"),      //ERROR WOULD NEED SOME WAY TO GET CURRENT PROFILE ID 
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8', // Set content type
        },
      );

    final data = jsonDecode(response.body);
    for(int i = 1; i < data["count"]; i++)//could break here
    {
      tempEvent = new Event();
      tempEvent.id = data["id" + i.toString()];
      tempEvent.name = data["name" + i.toString()];
      tempEvent.pinId = data["pinId" + i.toString()];
      tempEvent.date = data["date" + i.toString()];
      dataToSend.add(tempEvent);
    }

    return dataToSend;
  }
}

