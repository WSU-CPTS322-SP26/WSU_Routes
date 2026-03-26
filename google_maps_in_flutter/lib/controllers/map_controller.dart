import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../container_classes/pin.dart';
import '../api_helper/maps_helper.dart';

class MapController 
{
  late GoogleMapController googController;
  MapsHelper helper = MapsHelper();

  Future<LatLng> getCamPosLat(BuildContext context) async
  {
    double x = MediaQuery.of(context).size.width * MediaQuery.of(context).devicePixelRatio / 2;
    double y = MediaQuery.of(context).size.height * MediaQuery.of(context).devicePixelRatio / 2;

    final Completer<GoogleMapController> completer = Completer<GoogleMapController>();
    completer.complete(googController);
    final GoogleMapController con = await completer.future;
    LatLng returnVal = await con.getLatLng(ScreenCoordinate(x: x.round(), y: y.round()));

    return returnVal;
  }

  Future<void> CreateNewPin(String name, bool isPublic, String description, BuildContext context) async
  {
    LatLng coords = await getCamPosLat(context);
    Pin tempPin = Pin(name, isPublic, description, coords.latitude, coords.longitude);
    helper.addNewPin(tempPin);
  }

  Future<void> getPins(Set<Marker> markers) async
  {
    List<Pin> list = [];
    final pins = await MapsHelper.getPublicPins();
    list.addAll(pins);

    markers.clear();
    for(var pin in pins )
    {
      print(pin.formatToPrint() + "\n");

      markers.add(Marker(
        markerId: MarkerId(pin.name),
        position: LatLng(pin.latitude, pin.longitude),
        infoWindow: InfoWindow(
          title: pin.name,
          snippet: pin.description,
        )
        )
      );
    }
  }

}