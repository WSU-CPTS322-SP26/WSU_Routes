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
  Event tempEvent = Event();

  @override
  void initState()
  {
    super.initState();

    
  }

  void loadInitalEvents() async
  {
    controller.InitalPublicEvents(list);//populates list
    update();
  }

  void onCreateEvent() async
  {
    await controller.PostEvent(tempEvent);
    await controller.InitalPublicEvents(list);

    update();
  }

  void update()
  {
    setState(() {
          // rebuild UI after controller updates value
        });
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
              body: 
              Center(
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
                            Text('NAME: ${list[index].name}, DATE: ${list[index].date}')
                        ],
                      )
                    ),

                    Row(children: [
                      ElevatedButton(onPressed: () { 
                      showDialog(
                        context: context,
                        builder: (context) 
                        {
                            TextEditingController nameController = TextEditingController();
                            TextEditingController dateController = TextEditingController();
                            bool isPublicTemp = true;

                            return StatefulBuilder(builder: (context, setStateDialog)
                            {
                              return AlertDialog(
                              title: Text("Create Event"),
                              content: Column(
                                children: [
                                  Text("Name:"),
                                  TextField(
                                    controller: nameController,
                                  ),
                                  Text("Private | Public:"),
                                  Switch(value: isPublicTemp, onChanged: (bool val) { setStateDialog(() {
                                      isPublicTemp = val;
                                    }); 
                                  }),
                                  Text("Date:"),
                                  TextField(
                                    controller: dateController,
                                  ),

                                  ElevatedButton(onPressed: () {
                                    tempEvent = Event();
                                    tempEvent.name = nameController.text;
                                    tempEvent.isPublic = isPublicTemp;
                                    tempEvent.date = dateController.text;
                                    onCreateEvent();
                                  }, child: Text("Submit")),
                                ]
                              )
                            );
                            });
                            
                        }
                      );
                      },
                      child: Text('Add Event'))
                    ],)
                    
                  ],

                ),
                

              ),

            )
    );
  }

}