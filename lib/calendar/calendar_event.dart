import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:parallax_image/parallax_image.dart';

import 'event_details.dart';
import 'get_event.dart';

class CalendarEvent extends StatelessWidget {
  final Event event;

  CalendarEvent({this.event});

  Future<List<Event>> listEvents() async {
    List<Event> events = await fetchEvents();
    return events;
  }

  bool sameDay(DateTime a, DateTime b) {
    DateTime dayA = new DateTime(a.year, a.month, a.day);
    DateTime dayB = new DateTime(b.year, b.month, b.day);
    return dayA == dayB;
  }

  Widget calendarTile(List<Event> events, BuildContext context) {
    List<Widget> eventTiles = [];
    for(int i = 0; i < events.length; i++) {
      eventTiles.add(eventTile(events[i], context));
    }
    return Container(child: Row(
        children: <Widget>[
          Expanded(flex: 2, child: dateTile(events[0], context)),
          Expanded(flex: 8, child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: eventTiles,
          )),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
    );
  }

  Widget eventTile(Event event, BuildContext context) {
    return Container(
      child: new Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: eventTileColor(event),
        ),
        child: new InkWell(
          child: Container(
            height: 30.0,
            child: Text(event.title, style: TextStyle(color: Colors.white)),
            padding: const EdgeInsets.all(8.0),
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
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 8.0),
    );
  }

  Widget dateTile(Event event, BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(DateFormat.E().format(event.startTime)),
          new Container(
            child: Text(
              DateFormat.d().format(event.startTime),
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
            ),
            padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
          ),
        ],
      ),
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
    );
  }

  List<Widget> calendarWidgets(List<Event> events, BuildContext context) {
    List<Widget> calendarWidgets = [];
    for(int i = 0; i < events.length; i++) {
      int month = events[i].startTime.month;
      List<Widget> monthWidgets = [];
      while(i < events.length && events[i].startTime.month == month) {
        List<Event> sameDayEvents = [];
        DateTime eventDay = events[i].startTime;
        while(i < events.length && sameDay(events[i].startTime, eventDay)) {
          sameDayEvents.add(events[i]);
          i++;
        }
        monthWidgets.add(calendarTile(sameDayEvents, context));
      }
      calendarWidgets.add(
        StickyHeaderBuilder(
          builder: (context, stuckAmount) {
            stuckAmount = stuckAmount.clamp(0.0, 1.0);
            return Container(
              height: 100 - (50 * (1 - stuckAmount)),
              alignment: Alignment.centerLeft,
              color: Colors.black,
              child: ParallaxImage(
                image: new AssetImage('assets/$month.jpg'),
                extent: 1000,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: textStroke(new DateFormat('MMMM').format(new DateTime(2019, month, 1))),
                  ),
                ),
              ),
              );
            },
          content: Column(children: monthWidgets),
        )
      );
    }
    return calendarWidgets;
  }

  Widget textStroke(String text) {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          text,
          style: TextStyle(
            fontSize: 20,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1
              ..color = Colors.blueGrey[900],
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Color eventTileColor(Event event) {
    if (event.categories == null || event.categories.length == 0) {
      return Colors.purple;
    }
    if (event.categories.length > 1) {
      return Colors.deepOrange;
    }
    if (event.categories[0] == "Festivals") {
      return Colors.red;
    }
    return Colors.teal;
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
