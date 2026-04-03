import '../api_helper/events_helper.dart';
import '../container_classes/event.dart';

class EventsController
{
  Future<void> InitalEvents(List<Event> list) async
  {
    list.clear();
    final privateEvents = await EventsHelper.GetPrivateEvents();
    
    final events = await EventsHelper.GetPublicEvents();
    list.addAll(events);
    list.addAll(privateEvents);
  }

  Future<void> PostEvent(Event event) async
  {
    await EventsHelper.PostNewEvents(event);
  }
}