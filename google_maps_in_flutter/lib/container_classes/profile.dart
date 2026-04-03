class CurProfile
{
  static final CurProfile _instance = CurProfile._internal(); //For Singleton
  CurProfile._internal(); //For Singleton

  String email = "";

  factory CurProfile() //For Singleton
  {
    return _instance;
  }
}