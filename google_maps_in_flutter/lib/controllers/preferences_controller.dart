import '../api_helper/preference_helper.dart';

class PreferencesController
{
  bool isNotif = true;
  bool isClub = false;

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




}