import '../api_helper/events_helper.dart';
import '../container_classes/event.dart';

class EventsController
{
  Future<List<Event>> InitalPublicEvents() async
  {
    return EventsHelper.GetPublicEvents();
  }
}