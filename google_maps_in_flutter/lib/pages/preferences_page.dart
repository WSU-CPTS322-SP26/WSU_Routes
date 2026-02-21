import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/preferences_controller.dart';

class PreferencesPage extends StatefulWidget
{

  @override 
  State<PreferencesPage> createState() => PrefState();

}

class PrefState extends State<PreferencesPage>
{
  final PreferencesController controller = PreferencesController();

  void onNotifChange(bool newVal) async {
    await controller.UpdateNotif(newVal);

    update();
  }

  void onClubChange(bool newVal) async {
    await controller.UpdateClub(newVal);

    update();
  }

  void onLocationPerfChange(bool newVal) async
  {
    await controller.UpdateLocationPermissions(newVal);

    update();
  }

  void update()
  {
    setState(() {
          // rebuild UI after controller updates value
        });
  }

  @override 
  Widget build(BuildContext context)//how the widget looks
  {
    return MaterialApp
    (
        home: Scaffold(
              appBar: AppBar(title: const Text("SOME DEMO")),
              body: Center(
                child: 
                Column
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(//title
                      "Options and Preferences:", style: const TextStyle(fontSize:24)
                    ),
                    Row(//For Notifications changes
                      children: [
                        Text(
                          "Notifications:",
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 20),
                        Switch(value: controller.isNotif, onChanged: onNotifChange),//switch for notif
                      ]
                    ),
                    Row(//For change to club profile
                      children: [
                        Text(
                          "Club Profile:",
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 20),
                        Switch(value: controller.isClub, onChanged: onClubChange)//switch for club
                      ]
                    ),
                    Row(//For change to location permissions
                      children: [
                        Text(
                          "Give Location Permissions:",
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 20),
                        Switch(value: controller.locationPermission, onChanged: onLocationPerfChange)//switch for club
                      ]
                    ),
                    Row(//For change to location permissions
                      children: [
                        const SizedBox(height: 20),
                        ElevatedButton(
                          child: const Text('Reset Password'),
                          onPressed: () 
                          {
                            print('Will send out email to reset password');
                          },
                        )
                      ]
                    ),
                  ],
                ),
              ),
            )
    );
  }

}


