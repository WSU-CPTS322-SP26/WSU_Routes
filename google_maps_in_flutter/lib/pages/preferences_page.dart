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
              body:Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Notifications:",
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    Switch(value: controller.isNotif, onChanged: onNotifChange)
                  ],
                )
              ),
            )
    );
  }

}


