import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/pages/preferences_page.dart';
import 'package:google_maps_in_flutter/pages/login_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

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
    home: LoginPage() //direct to login page on boot
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//Map interface is the homescreen -> displayed once signed in
class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;

  final LatLng _center =
      const LatLng(46.731283215181065, -117.16155184037612);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
