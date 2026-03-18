class Pin
{
  String id = "";
  String name = "";
  bool isPublic = false;
  double latitude = 0.0;
  double longitude = 0.0;
  String description = "";

  Pin(String name, bool isPublic, String description, double lat, double long)
  {
    this.name = name;
    this.description = description;
    this.isPublic = isPublic;
    this.latitude = lat;
    this.longitude = long;
  }
}