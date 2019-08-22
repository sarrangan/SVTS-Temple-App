import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  bool isTempleNews = false;
  bool isVolunteerNews = false;
  bool isCampNews = false;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.mail),
              labelText: 'Email Address',
            ),
            validator: (value) {
              return value.isEmpty ? "Please enter an email address" : null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'First Name',
            ),
            validator: (value) {
              return value.isEmpty ? "Please enter your first name" : null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Last Name',
            ),
            validator: (value) {
              return value.isEmpty ? "Please enter your last name" : null;
            },
          ),
          Text("Please select at least one of the following interest",
              style: TextStyle(fontWeight: FontWeight.bold),),
          Text(
              "Receive our bimonthly Temple newsletter, including news about festivals, classes, workshops and events"),
          CheckboxListTile(
              title: Text("Temple News"),
              value: isTempleNews,
              onChanged: (bool newValue) {
                setState(() {
                  isTempleNews = newValue;
                });
              }),
          Text("Receive information about special volunteering opportunities"),
          CheckboxListTile(
              title: Text("Volunteer News"),
              value: isVolunteerNews,
              onChanged: (bool newValue) {
                setState(() {
                  isVolunteerNews = newValue;
                });
              }),
          Text(
              "Receive alerts about registering your child(ren) for our yearly summer Camp"),
          CheckboxListTile(
              title: Text("VSI (Camp) News"),
              value: isCampNews,
              onChanged: (bool newValue) {
                setState(() {
                  isCampNews = newValue;
                });
              }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
