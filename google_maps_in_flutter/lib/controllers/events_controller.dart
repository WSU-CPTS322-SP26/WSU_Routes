import '../api_helper/events_helper.dart';
import '../container_classes/event.dart';

class EventsController
{
  Future<void> InitalPublicEvents(List<Event> list) async
  {
    list.clear();
    list.addAll(await EventsHelper.GetPublicEvents());
  }

  Future<void> PostEvent(Event event) async
  {
    await EventsHelper.PostNewEvents(event);
  }



}