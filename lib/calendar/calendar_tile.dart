import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parallax_image/parallax_image.dart';

import 'event_details.dart';
import 'get_event.dart';

Widget calendarHeader(int month) {
  return ParallaxImage(
    image: new AssetImage('assets/$month.jpg'),
    extent: 1000,
    child: Stack(
      children: [
        Container(
          height: 350.0,
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.bottomLeft,
              colors: [
                Colors.grey.withOpacity(0.0),
                Colors.black,
              ],
              stops: [
                0.0,
                1.0
              ]
            )
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: textStroke(new DateFormat('MMMM').format(new DateTime(2019, month, 1))),
          ),
        ),
      ],
    )
  );
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
          child: Text(event.title, style: TextStyle(color: Colors.white), softWrap: false),
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
        ),
        onTap: (){
            Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return new EventDetails(event: event);
              },
              fullscreenDialog: true,
            ),
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