import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/pages/preferences_page.dart';
import 'package:google_maps_in_flutter/pages/login_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp( //load firebase before running app
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
  //runApp(PreferencesPage()); //need to reintegrate (possible create side bar/menu?)
  
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
    home: AuthGate() //direct to login page -> after login goes to map
    );
  }
}


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData) {
          return LoginPage(); //direct to a login page if logged out, defined in login_page.dart
        }

        return HomePage(); //go to home/map if logged in 
      },
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); //allow user to sign out
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
