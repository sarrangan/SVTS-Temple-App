import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'get_event.dart';

class EventDetails extends StatelessWidget {
  final Event event;

  EventDetails({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: SingleChildScrollView(
        child: Html(data: event.description, onLinkTap: (String url) => launch(url)),
      ),
    );
  }
}