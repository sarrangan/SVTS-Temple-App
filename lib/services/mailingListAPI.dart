import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svts_temple_app/models/contacts.dart';


// Define a custom Form widget.
class MailingListForm extends StatefulWidget {
  @override
  MailingListFormState createState() {
    return MailingListFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MailingListFormState extends State<MailingListForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _user = User();

  
  void _submit() async {
    final form = _formKey.currentState;
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (form.validate()) {
      form.save();
      try {
        String result = await _user.save();
      } catch (e) {
        String emailIdError = "Member already exists";
      }
      _showDialog(context);
    }
  }

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
              value: _user.mailInterests[User.TempleNews],
              onChanged: (bool newValue) =>
                  setState(() => _user.mailInterests[User.TempleNews] = newValue)
          ),
          Text("Receive information about special volunteering opportunities"),
          CheckboxListTile(
              title: Text("Volunteer News"),
              value: _user.mailInterests[User.VolunteerNews],
              onChanged: (bool newValue) =>
                  setState(() => _user.mailInterests[User.VolunteerNews] = newValue)
          ),
          Text(
              "Receive alerts about registering your child(ren) for our yearly summer Camp"),
          CheckboxListTile(
              title: Text("VSI (Camp) News"),
              value: _user.mailInterests[User.VSINews],
              onChanged: (bool newValue) =>
                  setState(() => _user.mailInterests[User.VSINews] = newValue)
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: _submit,
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

// https://github.com/mmcc007/modal_progress_hud/blob/master/example/lib/main.dart
// For server side validation of email address

//{
//    "email_address": "anagayan.ariaran@gmail.com",
//    "status": "subscribed",
//    "merge_fields": {
//        "FNAME": "Anagayan",
//        "LNAME": "Ariaran"
//    },
//		"interests": {
//			"ca903fe669": true, Temple
//			"32c1cd062c": true, Volunteer
//			"32936e01ff": true  Camp
//		}
//}