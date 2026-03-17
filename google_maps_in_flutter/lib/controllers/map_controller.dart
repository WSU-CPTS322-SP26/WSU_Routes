import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController 
{
  late GoogleMapController googController;
  LatLng CamPos = new LatLng(0, 0);


  Future<void> getCamPosLat(context) async
  {
    double x = MediaQuery.of(context).size.width * MediaQuery.of(context).devicePixelRatio / 2;
    double y = MediaQuery.of(context).size.height * MediaQuery.of(context).devicePixelRatio / 2;

    final Completer<GoogleMapController> completer = Completer<GoogleMapController>();
    completer.complete(googController);
    final GoogleMapController con = await completer.future;
    LatLng returnVal = await con.getLatLng(ScreenCoordinate(x: x.round(), y: y.round()));

    this.CamPos = returnVal;
  }

}