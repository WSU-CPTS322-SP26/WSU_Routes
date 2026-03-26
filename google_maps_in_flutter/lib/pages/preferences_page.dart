import 'package:flutter/material.dart';
import '../controllers/preferences_controller.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PreferencesPage extends StatefulWidget {
  final String userId;
  const PreferencesPage({required this.userId}); //need to take in id as parameter to properly mod db

  @override
  State<PreferencesPage> createState() => PrefState();
}

class PrefState extends State<PreferencesPage> {

  bool isNotif = true; //on by default
  bool isClub = false;
  bool locationPerm = false;

  //http request destinations
  final String baseUrl = 'http://10.0.2.2:5000';
  //final PreferencesController controller = PreferencesController();


  void onNotifChange(bool newVal) async {
    setState(() => isNotif = newVal);
    await http.put(
      Uri.parse('$baseUrl/profile/${widget.userId}/notifOn'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'notifOn': newVal}),
    );
    //update();
  }

  void onClubChange(bool newVal) async {
    //await controller.UpdateClub(newVal);
    setState(() => isClub = newVal);
      await http.put(
      Uri.parse('$baseUrl/profile/${widget.userId}/isClub'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'isClub': newVal}),
    );
  }

  void onLocationPerfChange(bool newVal) async {

      setState(() => locationPerm = newVal);
      await http.put(
      Uri.parse('$baseUrl/profile/${widget.userId}/locationPermission'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'locationPermission': newVal}),
    );
  }

  void update() {
    setState(() {
      // rebuild UI after controller updates value
    });
  }

  @override
  Widget build(BuildContext context) //how the widget looks
  {
    
    return Scaffold(
      appBar: AppBar(title: const Text("Prefences Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              //title
              "Options and Preferences:",
              style: const TextStyle(fontSize: 24),
            ),
            Row(
              //For Notifications changes
              children: [
                Text("Notifications:", style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                Switch(
                  value: isNotif,
                  onChanged: onNotifChange,
                ), //switch for notif
              ],
            ),
            Row(
              //For change to club profile
              children: [
                Text("Club Profile:", style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                Switch(
                  value: isClub,
                  onChanged: onClubChange,
                ), //switch for club
              ],
            ),
            Row(
              //For change to location permissions
              children: [
                Text(
                  "Give Location Permissions:",
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                Switch(
                  value: locationPerm,
                  onChanged: onLocationPerfChange,



                ), //switch for club
              ],
            ),
            Row(
              //For change to location permissions
              children: [
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Reset Password'),
                  onPressed: () {
                    print('Will send out email to reset password');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
