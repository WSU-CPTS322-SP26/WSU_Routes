import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/events_controller.dart';
import '../container_classes/event.dart';

class EventsPage extends StatefulWidget
{

  @override 
  State<EventsPage> createState() => EventState();

}

class EventState extends State<EventsPage>
{
  final EventsController controller = EventsController();//instance of events controller
  List<Event> list = [];

  EventState()
  {
    controller.InitalPublicEvents(list);//populates list
  }

/////////////////////////////FROM LIST OF EVENTS NEED TO POPULATE UI WITH THE EVENTS SO CAN SEE THEM!!!!!!!!!!!!!!!!//////////// 
////ALSO NEED UI OPTION TO ADD EVENT AND FILL WITH PROPER DATA!!!!!!!!!!!!!!!
///THEN THAT GETS UPDATED TO DB!!!!!!!!!!!!!!!!!
    @override 
  Widget build(BuildContext context)//how the widget looks
  {
    return MaterialApp
    (
        home: Scaffold(
              appBar: AppBar(title: const Text("Events Page")),
              body: Center(
                child: 
                Column
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: 
                  [
                    ...List.generate(
                      list.length,
                      (index) => Row(
                        children: [
                            Text('${list[index].name}, ${list[index].date}')
                        ],
                      )
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: ElevatedButton(onPressed: onPressed, child: Text("Create New Event")),
              ),
            )
    );
  }

}