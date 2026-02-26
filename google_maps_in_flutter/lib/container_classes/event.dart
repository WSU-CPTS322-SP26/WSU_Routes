
class Event
{
  String id = "";
  String name = "";
  String pinId = "";
  bool isPublic = false;
  String date = "";

  String formatToPrint()
  {
    return "id:" + id + ", name:" + name + ", pinID:" + pinId + ", isPublic:" + isPublic.toString() + ", date:" + date; 
  }
}