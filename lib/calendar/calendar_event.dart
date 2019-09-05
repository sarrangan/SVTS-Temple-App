import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

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

  List<Widget> calendarWidgets(List<Event> events, BuildContext context) {
    List<Widget> calendarWidgets = [];
    for(int i = 0; i < events.length; i++) {
      int month = events[i].startTime.month;
      List<Widget> monthWidgets = [];
      while(i < events.length && events[i].startTime.month == month) {
        monthWidgets.add(calendarTile(events[i], context));
        i++;
      }
      calendarWidgets.add(
        StickyHeader(
          header: Container(
            height: 50,
            color: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              new DateFormat('MMMM').format(new DateTime(2019, month, 1)),
              style: const TextStyle(color: Colors.white),
              ),
            ),
          content: Column(children: monthWidgets),
        ),
      );
    }
    return calendarWidgets;
  }

  Widget calendar(List<Event> events, BuildContext context) {
    List<Widget> calendarW = calendarWidgets(events, context);
    return ListView.builder(
      itemCount: calendarW.length,
      itemBuilder: (context, index) {
        return calendarW[index];
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
