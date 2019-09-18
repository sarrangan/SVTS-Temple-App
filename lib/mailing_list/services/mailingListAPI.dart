import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/contacts.dart';


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
  final _user = User();

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
              if (value.isEmpty) {
                return 'Please enter your email address';
              }
              return null;
            },
            onSaved: (value) =>
                setState(() => _user.email = value),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'First Name',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
            onSaved: (value) =>
                setState(() => _user.fName = value),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Last Name',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
            onSaved: (value) =>
                setState(() => _user.lName = value),
          ),
          Text(
            "Please select at least one of the following interest",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "Receive our bimonthly Temple newsletter, including news about festivals, classes, workshops and events"),
          CheckboxListTile(
              title: Text("Temple News"),
              value: _user.mailingLists[User.TempleNews],
              onChanged: (bool newValue) =>
                  setState(() => _user.mailingLists[User.TempleNews] = newValue)
          ),
          Text("Receive information about special volunteering opportunities"),
          CheckboxListTile(
              title: Text("Volunteer News"),
              value: _user.mailingLists[User.VolunteerNews],
              onChanged: (bool newValue) =>
                  setState(() => _user.mailingLists[User.VolunteerNews] = newValue)
          ),
          Text(
              "Receive alerts about registering your child(ren) for our yearly summer Camp"),
          CheckboxListTile(
              title: Text("VSI (Camp) News"),
              value: _user.mailingLists[User.VSINews],
              onChanged: (bool newValue) =>
                  setState(() => _user.mailingLists[User.VSINews] = newValue)
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                final form = _formKey.currentState;
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (form.validate()) {
                  form.save();
                  _user.save();
                  _showDialog(context);
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

_showDialog(BuildContext context) {
  Scaffold.of(context)
      .showSnackBar(SnackBar(content: Text('Submitting form')));
}
