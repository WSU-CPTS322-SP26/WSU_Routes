import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_in_flutter/container_classes/profile.dart';
import 'package:http/http.dart' as http;
import '../container_classes/event.dart';

class 
EventsHelper 
{
  static const String baseUrl = "http://10.0.2.2:5000";

  static Future<List<Event>> GetPublicEvents() async
  {
    List<Event> dataToSend = []; 
    Event tempEvent;

    final response = await http.get(Uri.parse("$baseUrl/events/public"), 
      );

    if(response.statusCode == 204)
    {
      return [];
    }

    final data = jsonDecode(response.body);
    for(int i = 0; i < data["count"]; i++)//could break here
    {
      tempEvent = new Event();
      tempEvent.id = data["id" + i.toString()];
      tempEvent.name = data["name" + i.toString()];
      tempEvent.pinId = data["pinId" + i.toString()];
      tempEvent.date = data["date" + i.toString()];
      tempEvent.description = data["description" + i.toString()];
      
      dataToSend.add(tempEvent);
      //print(tempEvent.formatToPrint()); // knows we get here correctly
    }

    return dataToSend;
  }

  static Future<List<Event>> GetPrivateEvents() async
  {
    List<Event> dataToSend = []; 
    Event tempEvent;
    String email = CurProfile().email; // singleton in action

    final response = await http.get(Uri.parse("$baseUrl/events/private/$email"), 
      );

    if(response.statusCode == 204)
    {
      return [];
    }

    final data = jsonDecode(response.body);
    for(int i = 0; i < data["count"]; i++)//could break here
    {
      tempEvent = new Event();
      tempEvent.id = data["id" + i.toString()];
      tempEvent.name = data["name" + i.toString()];
      tempEvent.pinId = data["pinId" + i.toString()];
      tempEvent.date = data["date" + i.toString()];
      tempEvent.description = "(PRIVATE) " + data["description" + i.toString()];
      
      dataToSend.add(tempEvent);
      //print(tempEvent.formatToPrint()); // knows we get here correctly
    }

    return dataToSend;
  }

  static Future<void> PostNewEvents(Event dataToCommit) async
  {
    if(dataToCommit.isPublic)
    {
      final response = await http.post(Uri.parse("$baseUrl/events/public"),      //ERROR WOULD NEED SOME WAY TO GET CURRENT PROFILE ID 
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8', // Set content type
          },
          body: jsonEncode({
            'name': dataToCommit.name,
            'isPublic': dataToCommit.isPublic,
            'date': dataToCommit.date,
            'description': dataToCommit.description
          })
        );
    }
    else
    {
      String email = CurProfile().email;

      final response = await http.post(Uri.parse("$baseUrl/events/private/$email"),      //ERROR WOULD NEED SOME WAY TO GET CURRENT PROFILE ID 
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8', // Set content type
          },
          body: jsonEncode({
            'name': dataToCommit.name,
            'isPublic': dataToCommit.isPublic,
            'date': dataToCommit.date,
            'description': dataToCommit.description,
            'email' : email
          })
        );
    }

  }


}

