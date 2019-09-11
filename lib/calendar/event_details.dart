import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'get_event.dart';

class EventDetails extends StatelessWidget {
  final Event event;

  EventDetails({Key key, @required this.event}) : super(key: key);

  Widget details() {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: [
          titleText(),
          dateText(),
          timeText(),
        ],
      ),
    );
  }

  Widget titleText() {
    String text = event.title;
    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      margin: EdgeInsets.only(left: 16.0, top:8.0, bottom: 8.0),
    );
  }

  Widget dateText() {
    String text = new DateFormat('EEEE, MMM d').format(event.startTime);
    return detailsText(text, Icon(Icons.today));
  }

  Widget timeText() {
    String text = new DateFormat.jm().format(event.startTime) + new DateFormat(' - ').add_jm().format(event.endTime);
    return detailsText(text, Icon(Icons.schedule));
  }

  Widget detailsText(String text, Icon icon) {
    Widget iconContainer = Container(
      child: icon,
      margin: EdgeInsets.only(left: 16, right: 16),
    );
    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            iconContainer,
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Column(
          children:[
          details(),
          Container(
            child: Html(data: event.description, onLinkTap: (String url) => launch(url)),
            margin: EdgeInsets.all(16.0),
          ),
        ],
      ),
    ));
  }
}