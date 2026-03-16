import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/pages/events_page.dart';
import 'package:google_maps_in_flutter/pages/preferences_page.dart';
import 'package:google_maps_in_flutter/pages/login_page.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

//Map interface is the homescreen -> displayed once signed in
class _MapPageState extends State<MapPage> 
{
  late GoogleMapController mapController;

  final LatLng _center =
      const LatLng(46.731283215181065, -117.16155184037612);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    //print("Map Created");
  }

  Future<LatLng> getCamPosLat() async
  {
    double x = MediaQuery.of(context).size.width * MediaQuery.of(context).devicePixelRatio / 2;
    double y = MediaQuery.of(context).size.height * MediaQuery.of(context).devicePixelRatio / 2;

    final Completer<GoogleMapController> completer = Completer<GoogleMapController>();
    completer.complete(mapController);
    final GoogleMapController con = await completer.future;
    LatLng returnVal = await con.getLatLng(ScreenCoordinate(x: x.round(), y: y.round()));

    return returnVal;
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: 
      FloatingActionButton(
        mini: true, 
        onPressed: getCamPosLat,
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        
        ),
      

    );
  }
}
