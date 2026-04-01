import 'package:flutter/material.dart';
import '../controllers/preferences_controller.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PreferencesPage extends StatefulWidget {
  final String userId;
  const PreferencesPage({required this.userId});

  @override
  State<PreferencesPage> createState() => PrefState();
}

class PrefState extends State<PreferencesPage> {
  late final PreferencesController controller;

  @override
  void initState() {
    super.initState();
    controller = PreferencesController(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preferences Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Options and Preferences:", style: TextStyle(fontSize: 24)),
            Row(
              children: [
                const Text("Notifications:", style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                Switch(
                  value: controller.isNotif,
                  onChanged: (newVal) async {
                    await controller.onNotifChange(newVal);
                    setState(() {});
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text("Club Profile:", style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                Switch(
                  value: controller.isClub,
                  onChanged: (newVal) async {
                    await controller.onClubChange(newVal);
                    setState(() {});
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text("Give Location Permissions:", style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                Switch(
                  value: controller.locationPermission,
                  onChanged: (newVal) async {
                    await controller.onLocationPermChange(newVal);
                    setState(() {});
                  },
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Reset Password'),
                  onPressed: () {
                    print('Will send out email to reset password');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}