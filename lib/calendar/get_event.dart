import 'dart:async';
import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

    var description = json['description'].toString().replaceAll(new RegExp("alt=(.*?)\""), "");
    var startDateDetails = json['start_date_details'];
    var endDateDetails = json['end_date_details'];
    return Event(
      title: json['title'],
      description: description,
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

class Events {
  Duration _cacheDuration = Duration(minutes: 10);
  DateTime _cachedTime;
  List<Event> _events;
  int monthsBefore = 4;
  Map eventsInMonth = Map();

  Events() {
    _cachedTime = DateTime.fromMillisecondsSinceEpoch(0);
    _events = [];
  }

  Future<List<Event>> forceRefreshCalendar() async {
    monthsBefore += 3;
    _cachedTime = DateTime.now();
    return fetchNineMonthsOfEvents();
  }

  Future<List<Event>> fetchEvents(bool forceRefresh) async {
    bool shouldRefresh = (null == _events || _events.isEmpty || _cachedTime.isBefore(DateTime.now().subtract(_cacheDuration)) || forceRefresh);
    if (shouldRefresh) _events = await refreshEvents();
    return _events;
  }

  Future<List<Event>> refreshEvents() async {
    _cachedTime = DateTime.now();
    return fetchNineMonthsOfEvents();
  }

  Future<List<Event>> fetchNineMonthsOfEvents() async {
    var now = new DateTime.now();
    var startDate = new DateTime(now.year, now.month - monthsBefore, 1);
    List<Future<List<Event>>> responses = [];
    for(int i = 0; i < 12; i++) {
      var date = new DateTime(startDate.year, startDate.month + i, 1);
      var monthEvents = fetchEventForMonth(date);
      responses.add(monthEvents);
    }

    List<List<Event>> nestedEvents = await Future.wait(responses);
    for (var events in nestedEvents) {
      if (events.length > 0) {
        var month = events[0].startTime.month;
        eventsInMonth[month] = events.length;
      }
    }
    return nestedEvents.expand((f) => f).toList();
  }

  Future<List<Event>> fetchEventForMonth(DateTime date) async {
    var monthStart = new DateTime(date.year, date.month, 1);
    var monthEnd = new DateTime(date.year, date.month + 1, 0);

    String monthStartString = new DateFormat('yyyy-MM-dd').format(monthStart);
    String monthEndString = new DateFormat('yyyy-MM-dd').format(monthEnd);

    final response = await http.get("https://srividya.org/wp-json/tribe/events/v1/events/?per_page=50&start_date=$monthStartString&end_date=$monthEndString&status=publish&page=1");
    // TODO: handle the next_url when there are more than 50 events jsonResponse['next_rest_url']
    if (response.statusCode == 200) {
      var unescape = new HtmlUnescape();
      Map<String, dynamic> jsonResponse = json.decode(unescape.convert(utf8.decode(response.bodyBytes)));
      List<dynamic> jsonEvents = jsonResponse['events'];
      List<Event> events = [];
      for(int i = 0; i < jsonEvents.length; i++) {
        Event event = Event.fromJson(jsonEvents[i]);
        events.add(event);
      }
      return events;
    } else {
      return fetchEventForMonth(date);
      // throw Exception('Failed to get calendar events for $monthStartString');
    }
  }

  double calendarScrollOffset() {
    var currMonth = DateTime.now().month;
    double offset = 0;
    for(int i = currMonth - monthsBefore; i < currMonth; i++){
      if(eventsInMonth[i] != null) {
        offset += 100;
        offset += eventsInMonth[i] * 65;
      }
    }
    return offset;
  }

}
