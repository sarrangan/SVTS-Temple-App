import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'event_details.dart';
import 'get_event.dart';

class CalendarEvent extends StatelessWidget {
  final Event event;

  CalendarEvent({this.event});
  
  Future<List<Event>> listEvents() async {
    List<Event> events = await fetchEvents();
    return events;
  }

  Widget calendarTile(Event event, BuildContext context) {
    return new Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: dateTile(event, context),
          ),
          Expanded(
            flex: 8,
            child: eventTile(event, context),
          ),
        ]
      ),
      margin: const EdgeInsets.only(top: 5, bottom: 5),
    );
  }

  Widget eventTile(Event event, BuildContext context) {
    return Container(
      child: new Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: const Color(0xff7c94b6),
        ),
        child: new InkWell(
          child: Container(
            child: Text(event.title, style: TextStyle(color: Colors.white)),
            padding: const EdgeInsets.all(5),
          ),
          onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventDetails(event: event)),
              );
          },
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5, bottom: 5),
    );
  }

  Widget dateTile(Event event, BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(DateFormat.E().format(event.startTime)),
          Text(
            DateFormat.d().format(event.startTime),
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5)),
        ],
        
      ),
    );
  }

  Widget calendar(List<Event> events, BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return calendarTile(events[index], context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: listEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return calendar(snapshot.data, context);
        } else if(snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      }
    );
  }
}
