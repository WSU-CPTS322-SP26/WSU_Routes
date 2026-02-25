import '../api_helper/events_helper.dart';
import '../container_classes/event.dart';

class EventsController
{
  Future<void> InitalPublicEvents(List<Event> list) async
  {
    list = await EventsHelper.GetPublicEvents();
  }
}