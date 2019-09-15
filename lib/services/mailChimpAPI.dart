import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:svts_temple_app/models/contacts.dart';
import 'package:svts_temple_app/config/configuration.dart';

String generateMd5(String input) {
  return md5.convert(utf8.encode(input.toLowerCase())).toString();
}

String constructAuthToken() {
  return 'Basic ' + base64Encode(utf8.encode('username:$apiKey'));
}

Future<String> getInfo(String email) async {
  final user = generateMd5(email);
  final url = '$baseUrl$user';

  final basicAuth = constructAuthToken();

  final response = await http
      .get(url, headers: <String, String>{'authorization': basicAuth});

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to retrieve data from: $url');
  }
}

Future<String> addContact(NewContact newContact) async {
  final url ='$baseUrl';
  final basicAuth = constructAuthToken();

  final body = json.encode(newContact);
  print(body);

  final response = await http.post(url,
      headers: <String, String>{'authorization': basicAuth, 'content-type': 'application/json'}, body: body);

  print(response);
  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    return response.body;
  }
  else if (response.statusCode == 400 && response.body.contains('Member Exists')) {
    throw MemberExistsException('Error - You are already subsribed to the mailing list');
  }
  else {
    throw Exception('Failed to retrieve data from: $url');
  }
}

class MemberExistsException implements Exception {
  final String message;
  const MemberExistsException(this.message);
  String toString() => 'MemberExistsException: $message';
}