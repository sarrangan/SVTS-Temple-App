import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Event>> fetchEvents() async {
  final response = await http.get('http://srividya.org/wp-json/tribe/events/v1/events');

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<dynamic> jsonEvents = jsonResponse['events'];
    List<Event> events = [];
    for(int i = 0; i < jsonEvents.length; i++) {
      Event event = Event.fromJson(jsonEvents[i]);
      events.add(event);
    }
    return events;
  } else {
    throw Exception('Failed to get calendar events');
  }
}

class Event {
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> categories;

  Event({this.title, this.description, this.categories, this.startTime, this.endTime});

  factory Event.fromJson(Map<String, dynamic> json) {
    List<String> categories = [];
    for(int i = 0; i < json['categories'].length; i++) {
      var category = json['categories'][i]['name'];
      categories.add(category);
    }
    var startDateDetails = json['start_date_details'];
    var endDateDetails = json['end_date_details'];
    return Event(
      title: json['title'],
      description: json['description'],
      categories: categories,
      startTime: DateTime(
        int.parse(startDateDetails['year']),
        int.parse(startDateDetails['month']),
        int.parse(startDateDetails['day']),
        int.parse(startDateDetails['hour']),
        int.parse(startDateDetails['minutes'])),
      endTime: DateTime(
        int.parse(endDateDetails['year']),
        int.parse(endDateDetails['month']),
        int.parse(endDateDetails['day']),
        int.parse(endDateDetails['hour']),
        int.parse(endDateDetails['minutes']))
    );
  }
}
