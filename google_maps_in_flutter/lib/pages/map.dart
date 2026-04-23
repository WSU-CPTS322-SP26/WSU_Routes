import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/pages/preferences_page.dart';
import 'package:google_maps_in_flutter/pages/events_page.dart';
import 'package:google_maps_in_flutter/custom_icons_icons.dart';
import 'package:google_maps_in_flutter/pages/login_page.dart';
import 'package:google_maps_in_flutter/api_helper/preference_helper.dart';
import '../controllers/map_controller.dart';
import '../container_classes/pin.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:custom_info_window/custom_info_window.dart';


class MapPage extends StatefulWidget {
  final String userId;
  final String email;
  const MapPage({super.key, required this.userId, required this.email});

  @override
  State<MapPage> createState() => _MapPageState();
}

//Map interface is the homescreen -> displayed once signed in
class _MapPageState extends State<MapPage> {
  late MapController mapController = new MapController();
  int uiState = 0;
  Set<Marker> markers = {};
  String mapStyle = "";
  bool isClubUser = false;
  

  final LatLng _center = const LatLng(46.731283215181065, -117.16155184037612);

  @override
  void initState() {
    super.initState();
    _loadClubStatus();
  }

  Future<void> _loadClubStatus() async {
    final bool clubStatus = await PreferenceHelper.getClubStatus(widget.userId);
    if (!mounted) return;

    setState(() {
      isClubUser = clubStatus;
    });
  }

  void _onMapCreated(GoogleMapController controller) async{
    mapController.googController = controller;
    mapController.googleMapController = controller;

    mapStyle = await rootBundle.loadString('assets/styleformap.json');
    mapController.googController.setMapStyle(mapStyle);
    loadPins();
    //print("Map Created");
  }

  void getCamPos(BuildContext context) {
    mapController.getCamPosLat(context);
  }

  Future<void> loadPins() async {
    await mapController.getPins(markers, context); //populates list
    markers.addAll(mapController.buildingMarkers);
    setState(() {
      markers;
    });
  }

  void UpdateUIState(int newVal) {
    setState(() {
      uiState = newVal; // rebuild UI after controller updates value
    });
  }

  int currentPageIndex = 0; // page index for the NavigationBar

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (uiState) {
      case 0: //Original State
        content = Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(right: 165)),
              FloatingActionButton(
                mini: false,
                onPressed: () => {UpdateUIState(1)},
                backgroundColor: Color.fromRGBO(166 , 15, 45, 1),
                child: Icon(Icons.add),
              ),
              FloatingActionButton(
                mini: false,
                onPressed: () => {loadPins()},
                backgroundColor: Color.fromRGBO(166 , 15, 45, 1),
                child: Icon(Icons.loop),
              ),
            ],
          ),
        );
        break;
      case 1: //getting location
        content = Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 530.0)),
                  Icon(Icons.push_pin, color: Colors.red, size: 50),
                ],
              ), //visual guide
            ),
            Align(
              alignment: Alignment
                  .bottomCenter, //buttons to go back or to select location
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(right: 165)),
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
                      showDialog(
                        //popup to put in pin details.
                        context: context,
                        builder: (context) {
                          TextEditingController nameController =
                              TextEditingController();
                          TextEditingController descriptionController =
                              TextEditingController();
                          bool isPublicTemp = true;

                          return StatefulBuilder(
                            builder: (context, setStateDialog) {
                              return AlertDialog(
                                title: Text("Create Pin"),
                                content: Column(
                                  children: [
                                    Text("Name:"),
                                    TextField(controller: nameController),
                                    Text("Private | Public:"),
                                    Switch(
                                      value: isPublicTemp,
                                      onChanged: (bool val) {
                                        setStateDialog(() {
                                          isPublicTemp = val;
                                        });
                                      },
                                    ),
                                    Text("Description:"),
                                    TextField(
                                      controller: descriptionController,
                                    ),

                                    ElevatedButton(
                                      onPressed: () {
                                        mapController.CreateNewPin(
                                          nameController.text,
                                          isPublicTemp,
                                          descriptionController.text,
                                          context,
                                        );
                                        UpdateUIState(0);
                                        Navigator.pop(context);
                                        loadPins();
                                      },
                                      child: Text("Submit"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    },
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check_box),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        content = Center(child: Text("NOT WORKING"));
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("WSU Routes"),
        actions: [
          if (isClubUser) //show club icon only when isClub is true in db
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.groups_2,
                size: 20,
                semanticLabel: 'Club account',
              ),
            ),
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
          ),
        ],
      ),
      body: 
      Stack(
        children: [
          GoogleMap(
        onMapCreated: _onMapCreated,
        style: mapStyle,
        initialCameraPosition: CameraPosition(target: _center, zoom: 17.0),
        markers: markers,
          onTap: (_) {
            mapController.hideInfoWindow!();
          },
          onCameraMove: (position) {
            mapController.onCameraMove!();
          },
      ),
      
      CustomInfoWindow(
        controller: mapController,
        height: 200, // Customize height and width
        width: 220,
        offset: 0, // Adjust offset as needed
      ),
      ]),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) async {
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EventsPage()),
            );
          }
          if (index == 4) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PreferencesPage(
                  userId: widget.userId,
                  email: widget.email,
                ),
              ),
            );
            _loadClubStatus();
          }
        },
        destinations: [
          NavigationDestination(
            icon: Icon(CustomIcons.custom_person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(CustomIcons.custom_pin_sharing),
            label: 'Pin_sharing',
          ),
          NavigationDestination(
            icon: Icon(CustomIcons.custom_organization),
            label: 'Organizations',
          ),
          NavigationDestination(
            icon: Icon(CustomIcons.custom_calendar),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(CustomIcons.custom_gear),
            label: 'Preferences',
          ),
        ],
        selectedIndex: currentPageIndex,
      ),

      floatingActionButton: content, //our defined content
    );
  }
}
