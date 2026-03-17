import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/pages/events_page.dart';
import 'package:google_maps_in_flutter/pages/preferences_page.dart';
import 'package:google_maps_in_flutter/pages/login_page.dart';
import '../controllers/map_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

//Map interface is the homescreen -> displayed once signed in
class _MapPageState extends State<MapPage> 
{
  late MapController mapController;
  int uiState = 0;

  final LatLng _center =
      const LatLng(46.731283215181065, -117.16155184037612);

  void _onMapCreated(GoogleMapController controller) {
    mapController.googController = controller;
    //print("Map Created");
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Sample App"),
        leading:
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PreferencesPage(),
                ),
              );
            },
          ),
  
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false, 
              );
              //print("User logged out");
            },
          )
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 17.0,
        ),
      ),   
    );
  } 
}

class OperatingButtons extends StatefulWidget
{
  const OperatingButtons({super.key});

  @override
  State<OperatingButtons> createState() => _OperatingButtonsState();

}

//Map interface is the homescreen -> displayed once signed in
class _OperatingButtonsState extends State<OperatingButtons> 
{
  late MapController mapController;
  int uiState = 0; 
  // 0 is opening state with option to add pin,

  @override
  Widget build(BuildContext context) {

      switch(uiState)
      {
        case 0:
        Center(child:
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          FloatingActionButton
          (
            mini: true, 
            onPressed: controller.getCamPosLat,
            backgroundColor: Colors.red,
            child: Icon(Icons.add),
          )
        ,)
        break;
        default: 
        break;
      }
  } 
}




  
