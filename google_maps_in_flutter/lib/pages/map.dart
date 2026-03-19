import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/pages/preferences_page.dart';
import 'package:google_maps_in_flutter/pages/login_page.dart';
import '../controllers/map_controller.dart';
import '../container_classes/pin.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

//Map interface is the homescreen -> displayed once signed in
class _MapPageState extends State<MapPage> 
{
  late MapController mapController = new MapController();
  int uiState = 0;
  Set<Marker> markers = {};

  final LatLng _center =
      const LatLng(46.731283215181065, -117.16155184037612);

  void _onMapCreated(GoogleMapController controller) {
    mapController.googController = controller;
    loadPins();
    //print("Map Created");
  }

  void getCamPos(BuildContext context)
  {
    mapController.getCamPosLat(context);
  }

  Future<void> loadPins() async
  {
    await mapController.getPins(markers);//populates list
    setState(() {
      markers;
    });
  }

  void UpdateUIState(int newVal)
  {
    setState(() {
         uiState = newVal; // rebuild UI after controller updates value
        });
  }

  @override
  Widget build(BuildContext context) 
  {
      Widget content;
      switch(uiState)
      {
        case 0: //Original State
        content = Align(
          alignment: Alignment.bottomCenter,
          child:
          Row(children: [
            FloatingActionButton
            (
              mini: false, 
              onPressed: () => {UpdateUIState(1)},
              backgroundColor: Colors.red,
              child: Icon(Icons.add),
            ),
            FloatingActionButton
            (
              mini: false, 
              onPressed: () => {loadPins()},
              backgroundColor: Colors.white,
              child: Icon(Icons.loop),
            ),

          ],)

        ,);
        break;
        case 1: //getting location
        content = Stack(
          children: [
          Align(alignment: Alignment.center,
          child: Icon(Icons.pin, color: Colors.red, size: 20,),//visual guide
          
          ),
          Align(alignment: Alignment.bottomCenter,//buttons to go back or to select location
          child: 
          Row(children: [
            FloatingActionButton // go back
            (
              mini: false, 
              onPressed: () => {UpdateUIState(0)},
              backgroundColor: Colors.red,
              child: Icon(Icons.arrow_back),
            ),
            FloatingActionButton // confirm
              (
                mini: false, 
                onPressed: () => {
                  showDialog(//popup to put in pin details.
                        context: context,
                        builder: (context) 
                        {
                            TextEditingController nameController = TextEditingController();
                            TextEditingController descriptionController = TextEditingController();
                            bool isPublicTemp = true;

                            return StatefulBuilder(builder: (context, setStateDialog)
                            {
                              return AlertDialog(
                              title: Text("Create Pin"),
                              content: Column(
                                children: [
                                  Text("Name:"),
                                  TextField(
                                    controller: nameController,
                                  ),
                                  Text("Private | Public:"),
                                  Switch(value: isPublicTemp, onChanged: (bool val) { setStateDialog(() {
                                      isPublicTemp = val;
                                    }); 
                                  }),
                                  Text("Description:"),
                                  TextField(
                                    controller: descriptionController,
                                  ),

                                  ElevatedButton(onPressed: () {
                                    mapController.CreateNewPin(nameController.text, isPublicTemp, descriptionController.text, context);
                                    UpdateUIState(0);
                                    Navigator.pop(context);
                                    loadPins();
                                  }, child: Text("Submit")),
                                ]
                              )
                            );
                            });
                        }
                      )
                },
                backgroundColor: Colors.green,
                child: Icon(Icons.check_box),
              ),
          ],)

          )
          ],
        );
        default: 
        content = Center (child: Text("NOT WORKING"),);
        break;
      }

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
      body: 
              GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 17.0,
              ),
              markers: markers,
            ),
      floatingActionButton: content,//our defined content
      

    );
  } 
}





  
