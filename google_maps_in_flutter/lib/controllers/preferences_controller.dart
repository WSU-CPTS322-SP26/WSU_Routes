import '../api_helper/preference_helper.dart';

class PreferencesController
{
  bool isNotif = true;//defaults, but once we have profile creation, will have get request to get the profile's preferences
  bool isClub = false;
  bool locationPermission = true;

  Future<void> UpdateNotif(bool newNotif) async
  {
    isNotif = newNotif;
    print(newNotif);
    PreferenceHelper.NotifChange(newNotif);
  }

  Future<void> UpdateClub(bool newClub) async
  {
    isClub = newClub;
    print(newClub);
    PreferenceHelper.ClubChange(newClub);
  }

  Future<void> UpdateLocationPermissions(bool newLocationPermission) async
  {
    locationPermission = newLocationPermission;
    print(newLocationPermission);
    PreferenceHelper.LocationPermissionChange(newLocationPermission);
  }

}