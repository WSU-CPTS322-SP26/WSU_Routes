import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../container_classes/pin.dart';
import '../api_helper/maps_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:custom_info_window/custom_info_window.dart';

class MapController extends CustomInfoWindowController
{
  late GoogleMapController googController;
  MapsHelper helper = MapsHelper();
  Set<Marker> buildingMarkers = Set<Marker>();

  Future<void> _launchUrl(Uri url) async //Taken from url launcher package documentation
  {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

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
                onTap: () 
        {
          addInfoWindow!(
            Container(
              decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)],
        ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pin.name, style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(pin.description)
                ],
              ),
            ),
            LatLng(46.73102477481042, -117.16225563581636)
          );
        },
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        )
      );
    }

    if(this.buildingMarkers.isEmpty)
    {
      setUpBuildings();
    }

    markers.addAll(buildingMarkers);
  }

  void setUpBuildings()
  {
    List<String> names = [];
    List<String> desc = [];
    List<LatLng> latlngs = [];
 
    //CUB
    names.add("Compton Union Building");
    desc.add("Social center, also named the CUB.");
    latlngs.add(LatLng(46.73102477481042, -117.16225563581636));

    //

    for(int i = 0; i < names.length; i++)
    {
      buildingMarkers.add(Marker(
          markerId: MarkerId(names[i]),
          position: latlngs[i],
          onTap: () 
          {
            addInfoWindow!(
              Container(
                decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)],
          ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(names[i], style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(desc[i]),
                  ],
                ),
              ),
              latlngs[i]
            );
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ));

    }
  }


}