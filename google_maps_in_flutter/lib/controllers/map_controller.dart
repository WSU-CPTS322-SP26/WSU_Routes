import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/container_classes/profile.dart';
import '../container_classes/pin.dart';
import '../api_helper/maps_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:custom_info_window/custom_info_window.dart';

class MapController extends CustomInfoWindowController {
  late GoogleMapController googController;
  MapsHelper helper = MapsHelper();
  Set<Marker> buildingMarkers = Set<Marker>();

  Future<void> _launchUrl(
    Uri url,
  ) async //Taken from url launcher package documentation
  {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<LatLng> getCamPosLat(BuildContext context) async {
    double x =
        MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio /
        2;
    double y =
        MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio /
        2;

    final Completer<GoogleMapController> completer =
        Completer<GoogleMapController>();
    completer.complete(googController);
    final GoogleMapController con = await completer.future;
    LatLng returnVal = await con.getLatLng(
      ScreenCoordinate(x: x.round(), y: y.round()),
    );

    return returnVal;
  }

  Future<void> CreateNewPin(
    String name,
    bool isPublic,
    String description,
    BuildContext context,
  ) async {
    LatLng coords = await getCamPosLat(context);
    Pin tempPin = Pin(
      name,
      isPublic,
      description,
      coords.latitude,
      coords.longitude,
    );
    if (isPublic) {
      helper.addNewPin(tempPin);
    } else {
      helper.addPrivatePin(tempPin);
    }
  }

  Future<void> getPins(Set<Marker> markers, BuildContext context) async {
    List<Pin> list = [];
    final pins = await MapsHelper.getPublicPins();
    final privatePins = await MapsHelper.getPrivatePins();
    list.addAll(pins);

    markers.clear();
    for (var pin in pins) {
      print(pin.formatToPrint() + "\n");

      markers.add(
        Marker(
          markerId: MarkerId(pin.name),
          position: LatLng(pin.latitude, pin.longitude),
          onTap: () {
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
                    Text(
                      pin.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(pin.description),
                  ],
                ),
              ),
              LatLng(pin.latitude, pin.longitude),
            );
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    for (var pin in privatePins) {
      print(pin.formatToPrint() + "\n");

      markers.add(
        Marker(
          markerId: MarkerId(pin.name),
          position: LatLng(pin.latitude, pin.longitude),
          onTap: () {
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
                    Text(
                      pin.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(pin.description),
                  ],
                ),
              ),
              LatLng(pin.latitude, pin.longitude),
            );
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow,
          ),
        ),
      );
    }

    if (this.buildingMarkers.isEmpty) {
      setUpBuildings(context);
    }

    markers.addAll(buildingMarkers);
  }

  void setUpBuildings(BuildContext context) {
    List<String> names = [];
    List<String> desc = [];
    List<LatLng> latlngs = [];
    List<CustomPainter> painters = [];
    List<Image> images = [];
    //CUB
    names.add("Compton Union Building (CUB)");
    desc.add(
      "Social center that holds majority of student events. Large areas for studying and food court.",
    );
    latlngs.add(LatLng(46.73102477481042, -117.16225563581636));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Abelson
    names.add("Abelson Hall");
    desc.add(
      "Location of School of Biological Sciences, plus its own rooftop greenhouse. Basement is home to Conner Natural History Museum.",
    );
    latlngs.add(LatLng(46.72977149767806, -117.16531272324524));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //CUE
    names.add("Smith Center for Undergraduate Education (CUE)");
    desc.add(
      "Home of varied WSU programs including the writing program, common reading program, and Writing Center.",
    );
    latlngs.add(LatLng(46.72980157164282, -117.1616604934845));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Engineering Building
    names.add("Electrical-Mechanical Engineering Building");
    desc.add(
      "Home of School of Electrical Engineering and Computer Science, School of Mechanical and Materials Engineering..",
    );
    latlngs.add(LatLng(46.73061483343902, -117.16935272877728));
    painters.add(EEMEPainter());
    images.add(Image.asset('assets/images/voiland-college-wayfinding-map.png'));

    //fulmer hall
    names.add("Fulmer Hall");
    desc.add(
      "Known as the Chemestry Building, Fulmer Hall is full of chem labs and said to have radioactive labs.",
    );
    latlngs.add(LatLng(46.729357873237696, -117.16431699358178));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //kimbrough
    names.add("Kimbrough Hall");
    desc.add(
      "Contains the School of Music and campus listening library, its crazy.",
    );
    latlngs.add(LatLng(46.73221746462215, -117.16501034467741));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //spark
    names.add("The Spark: Academic Innovation Hub");
    desc.add(
      "STEM learning center, creative headquarters, full of classrooms and study rooms.",
    );
    latlngs.add(LatLng(46.72816320466636, -117.16553630175655));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //terrell library
    names.add("Holland and Terrell Libraries");
    desc.add(
      "The big libraries on campus full of manuscripts, archives, collections, and study rooms. Connects to the CUB.",
    );
    latlngs.add(LatLng(46.73136830475717, -117.1637646504211));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Todd hall
    names.add("Todd Hall");
    desc.add(
      "Full of a bunch of classrooms, carson college of business, and miscellaneous empty classrooms to make advantage of.",
    );
    latlngs.add(LatLng(46.729904899183694, -117.16390513443224));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //beasley coliseum
    names.add("Beasley Coliseum");
    desc.add(
      "The cougar Coliseum, used for basketball games, job fairs, and concerts.",
    );
    latlngs.add(LatLng(46.73526391682103, -117.1580793145299));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Stephenson
    names.add("Stephenson Complex");
    desc.add(
      "With its own gym, this dorm has three wing towers. Nobody talks about the east tower, nobody likes it.",
    );
    latlngs.add(LatLng(46.726039307181416, -117.16596636455296));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //owen library
    names.add("Owen Science and Engineering Library");
    desc.add(
      "Engineering library full of engineering books, who could've thought.",
    );
    latlngs.add(LatLng(46.72887649686552, -117.16542457164435));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //art museum
    names.add("Jordan Schnitzer Museum of Art");
    desc.add("The crimson cube on campus that has rotating exhibition of art.");
    latlngs.add(LatLng(46.73037064635235, -117.16168599456348));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));


    //stadium
    names.add("Martin Stadium");
    desc.add("Big football stadium with 40,000 seats, Go Cougs!");
    latlngs.add(LatLng(46.73188120791032, -117.1605745759999));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Daggy Hall
    names.add("Daggy Hall");
    desc.add(
      "Home to Jones Theatre, School of Design and Construction, hangout spot for airforce cadets.",
    );
    latlngs.add(LatLng(46.7294873960086, -117.1675974693327));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Regenets Hall
    names.add("Regents Hall");
    desc.add("One of the big dorms on northside, its alright.");
    latlngs.add(LatLng(46.73406718969151, -117.16239987995246));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Northside dorm
    names.add("Northside Residence Hall");
    desc.add("The other big dorm on northside, its also alright.");
    latlngs.add(LatLng(46.734321014587785, -117.16122388880197));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));
  

    //Northside cafe
    names.add("Northside Cafe");
    desc.add(
      "Cafeteria for northside, ok food, and directly connected to northside dorm",
    );
    latlngs.add(LatLng(46.734513804570625, -117.16279984915086));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //bear center
    names.add("Bear Center");
    desc.add(
      "Home of the bears, the only grizzly bears research center of its kind in the US.",
    );
    latlngs.add(LatLng(46.7297220167878, -117.13891035779392));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Chinook
    names.add("Chinook Student Center");
    desc.add("Full of hangout spots, food, study spots, and a full guym.");
    latlngs.add(LatLng(46.73276172977122, -117.16549472558029));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Bryan Clock tower
    names.add("Bryan Clock Tower");
    desc.add("Beautiful, ain't it.");
    latlngs.add(LatLng(46.7313651470953, -117.16525190463996));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Southside Routundra
    names.add("Southside Rotunda");
    desc.add(
      "Upstairs is home to a cafeteria, while downstairs is a full convience store with ice cream.",
    );
    latlngs.add(LatLng(46.727091501242406, -117.16322176773734));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //wilson short
    names.add("Wilson-Short Hall");
    desc.add(
      "Home of Dept of Criminal Justice, but have classrooms for anything.",
    );
    latlngs.add(LatLng(46.7303367891336, -117.16248468406896));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //vet center
    names.add("Vet and Biomed Research Building");
    desc.add("Full of devices you've never seen in your life.");
    latlngs.add(LatLng(46.728801157121296, -117.15916603801023));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Ferdinand's
    names.add("Ferdinand's Ice Cream Shoppe");
    desc.add("Class coug ice cream joint.");
    latlngs.add(LatLng(46.732664852010664, -117.15483937915336));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Cleveland Hall
    names.add("Cleveland Hall");
    desc.add("Home to college of education, and the math learning center.");
    latlngs.add(LatLng(46.72865027288818, -117.16622244357157));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Rogers hall
    names.add("Rogers Hall");
    desc.add("Big ol dorm, paired with Orton Hall.");
    latlngs.add(LatLng(46.725931709494745, -117.16446082223122));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Orton Hall
    names.add("Orton Hall");
    desc.add("Another southside dorm, paired with Rogers Hall");
    latlngs.add(LatLng(46.72596480472493, -117.16336111652332));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //webster hall
    names.add("Webster Hall");
    desc.add(
      "Known as the physics building, home of physics department and assorted classrooms.",
    );
    latlngs.add(LatLng(46.72869257727076, -117.1636940016231));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //hillside cafe
    names.add("Hillside Cafe");
    desc.add("Main cafeteria for hillside, got good calzones.");
    latlngs.add(LatLng(46.73279866106276, -117.16682471224367));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //Neill Hall
    names.add("Neill Hall");
    desc.add("Big dorm named after Judge Thomas Neill");
    latlngs.add(LatLng(46.72830861927196, -117.16378810950211));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    //health services
    names.add("Cougar Health Services");
    desc.add("Building that provides health services to all coug at WSU.");
    latlngs.add(LatLng(46.72741029374321, -117.16614112257369));
    painters.add(BuildingPainter());
    images.add(Image.asset('assets/images/default image.png'));

    for (int i = 0; i < names.length; i++) {
      buildingMarkers.add(
        Marker(
          markerId: MarkerId(names[i]),
          position: latlngs[i],
          onTap: () {
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
                    Text(
                      names[i],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(desc[i]),

                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            insetPadding: EdgeInsets.all(16),
                            child: SizedBox(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              child: InteractiveViewer(
                                panEnabled: true,
                                scaleEnabled: true,
                                boundaryMargin: EdgeInsets.all(500),
                                child: images[i]
                              ),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.map),
                    ),
                  ],
                ),
              ),
              latlngs[i],
            );
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }
  }
}

class BuildingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    final sizeRect = Size(300, 300);
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawRect(center & sizeRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class EEMEPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    final sizeRect = Size(300, 300);
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawRect(center & sizeRect, paint);
    final path = Path()
      ..moveTo(50, 50)
      ..lineTo(50, 250)
      ..lineTo(200, 250)
      ..lineTo(200, 200)
      ..lineTo(100, 200)
      ..lineTo(100, 50)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
