import '../api_helper/preference_helper.dart';

class PreferencesController {
  final String userId;

  bool isNotif = true;
  bool isClub = false;
  bool locationPermission = false;

  PreferencesController({required this.userId});

  Future<void> onNotifChange(bool newVal) async {
    isNotif = newVal;
    await PreferenceHelper.updateNotif(userId, newVal);
  }

  Future<void> onClubChange(bool newVal) async {
    isClub = newVal;
    await PreferenceHelper.updateClub(userId, newVal);
  }

  Future<void> onLocationPermChange(bool newVal) async {
    locationPermission = newVal;
    await PreferenceHelper.updateLocationPermission(userId, newVal);
  }
}