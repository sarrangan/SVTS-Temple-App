import 'dart:async';
import 'dart:convert';

import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';


class VolunteerForm extends StatefulWidget {
  @override
  VolunteerFormState createState() {
    return VolunteerFormState();
  }
}

class VolunteerDetails {
  String fname;
  String lname;
  String famMembers;
  DateTime startDate;
  DateTime endDate;
  String accomodation = 'Yes';
  String guardian;
  String phoneNumber;
  TimeOfDay time;

  Map<String, String> toMap() {
    return {
      'Field1': fname,
      'Field2': lname,
      'Field3': famMembers,
      'Field4': phoneNumber,
      'Field5': DateFormat('MM d y').format(startDate),
      'Field6': DateFormat('MM d y').format(endDate),
      'Field7': accomodation,
      'Field8': time.hour.toString() + ':' + time.minute.toString(),
      'Field10': guardian, 
    };
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class VolunteerFormState extends State<VolunteerForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  String dropdownValue = 'Yes';
  final user = VolunteerDetails();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            autovalidate: true,
            autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'First Name'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'This field is mandatory';
              }
              return null;
            },
            onSaved: (value) {
              user.fname = value;
            },
          ),
          TextFormField(
            autovalidate: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Last Name'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'This field is mandatory';
              }
              return null;
            },
            onSaved: (value) {
              user.lname = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Names of other Family Members'
            ),
            onSaved: (value) {
              user.famMembers = value;
            },
          ),
          Row(children: [
            Expanded(child: TextFormField(
              onTap: () { _chooseDate(context, DateTime.now());},
              controller: _startDateController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Date of Arrival'
              ),
              validator: (value) {
                if(_startDateController.text.isEmpty || _endDateController.text.isEmpty) {
                  return 'Please select a date';
                }
                try {
                  DateTime.parse(_startDateController.text);
                } catch (e) {
                  return 'Start Date is invalid';
                }
                return null;
              },
              onSaved: (value) {
                user.startDate = DateTime.parse(_startDateController.text);
              },
            )),
            Expanded(child: TextFormField(
              onTap: () { _chooseDate(context, DateTime.now());},
              controller: _endDateController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Date of Departure'
              ),
              validator: (value) {
                if(_endDateController.text.isEmpty) {
                  return null;
                }
                try {
                  DateTime.parse(_endDateController.text);
                } catch (e) {
                  return 'End Date is invalid';
                }
                return null;
              },
              onSaved: (value) {
                user.endDate = DateTime.parse(_endDateController.text);
              },
            )),
          ],),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            autovalidate: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Phone Number'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a phone number';
              }
              if (value.length < 10) {
                return 'Phone number must be at least 10 digits long';
              }
              return null;
            },
            onSaved: (value) {
              user.phoneNumber = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Underage Guardian'
            ),
            onSaved: (value) {
              user.guardian = value;
            }
          ),
          Text("Are you requesting to stay in the Cabin or Temple House?"),
          DropdownButton<String>(
            value: user.accomodation,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
              color: Colors.deepPurple
            ),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                user.accomodation = newValue;
              });
            },
            items: <String>['Yes', 'No']
              .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toList(),
          ),
          TextFormField(
            onTap: (){ _chooseTime(context, DateTime.now());},
            controller: _timeController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'What time can you start volunteering?'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please select a time';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  _formKey.currentState.save();
                  submitForm(user);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
    ),
    ));
  }

  final TextEditingController _startDateController = new TextEditingController();
  final TextEditingController _endDateController = new TextEditingController();
  final TextEditingController _timeController = new TextEditingController();
  Future _chooseDate(BuildContext context, DateTime initialDate) async {
    var result = await DateRangePicker.showDatePicker(
        context: context,
        initialFirstDate: initialDate,
        initialLastDate: initialDate,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime.now().add(Duration(days: 360)),
    );

    if (result == null || result.length != 2) return;

    setState(() {
      _startDateController.text = DateFormat('y-MM-d').format(result[0]);
      _endDateController.text = DateFormat('y-MM-d').format(result[1]);
    });
  }

  Future _chooseTime(BuildContext context, DateTime initialDate) async {
    var result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (result == null) return;
    TimeOfDay time = result;
    setState(() {
      _timeController.text = result.format(context);
      user.time = result;
    });
  }

  DateTime convertToDate(String input) {
    try 
    {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }    
  }
  @override
  void dispose() {
      _startDateController.dispose();
      _endDateController.dispose();
      _timeController.dispose();
      super.dispose();
    }

  Future<String> submitForm(VolunteerDetails details) async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
    final apiKey = remoteConfig.getString('wufoo_key');

    final url = Uri.parse('https://svtsoffice.wufoo.com/api/v3/forms/z19i2tom0qh2quj/entries.json');
    final header = 'Basic ' + base64Encode(utf8.encode(apiKey));
    var request = http.MultipartRequest("POST", url);
    request.headers.addAll({'authorization': header, 'content-type': 'multipart/form-data'});
    final userMap = details.toMap();
    userMap.forEach((k,v) => request.fields[k] = v);
    final response = await request.send();
    final body = await response.stream.bytesToString();
    if (response.statusCode != 200 || response.statusCode != 201) {
      return 'There was an error submitting the form. Please try again later.';
    }
    return null;
  }
}