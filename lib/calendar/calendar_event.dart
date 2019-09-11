import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'calendar_tile.dart';
import 'get_event.dart';

class CalendarEvent extends StatelessWidget {

  Future<List<Event>> listEvents() async {
    List<Event> events = await fetchEvents();
    return events;
  }

  bool sameDay(DateTime a, DateTime b) {
    DateTime dayA = new DateTime(a.year, a.month, a.day);
    DateTime dayB = new DateTime(b.year, b.month, b.day);
    return dayA == dayB;
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
              child: calendarHeader(month),
              );
            },
          content: Column(children: monthWidgets),
        )
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
