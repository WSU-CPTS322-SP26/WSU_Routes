import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/pages/events_page.dart';
import 'package:google_maps_in_flutter/pages/preferences_page.dart';
import 'package:google_maps_in_flutter/pages/login_page.dart';
import 'pages/map.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

//For accessing events page, need to add a button
/*   runApp( 
    MaterialApp(
      home: EventsPage(),
    )
  ); */

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
    theme: ThemeData( 
    useMaterial3: true,
    colorSchemeSeed: Colors.green[700],
    ),
    home: MapPage() //direct to login page on boot
    );
  }
}
