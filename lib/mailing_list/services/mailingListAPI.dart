import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svts_temple_app/mailing_list/services/mailChimpAPI.dart';
import '../models/contacts.dart';

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

//  Form Controllers
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  bool isTempleNews = false;
  bool isVolunteerNews = false;
  bool isVSINews = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<String> validateEmail(payload) async {
    final form = _formKey.currentState;
    if (form.validate()) {
      Map<String, bool> userInterests = Map.from(payload['interests']);
      userInterests.removeWhere((key, value) => value == false);

      NewContact contact = NewContact(
          emailAddress: payload['email'],
          mergeFields: MergeFields(
              firstName: payload['firstName'], lastName: payload['lastName']),
          interests: userInterests);

      final response = await addContact(contact);

      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(response['title'], textAlign: TextAlign.center),
            content: Text(response['message'], textAlign: TextAlign.center),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    // Build a Form widget using the _formKey created above.
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Email Sign Up Form", style: TextStyle(fontSize: 20)),
        ),
        body: new SafeArea(
            top: false,
            bottom: true,
            child: new Form(
              key: _formKey,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'First Name',
                        ),
                        controller: firstNameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Last Name',
                        ),
                        controller: lastNameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.mail),
                          labelText: 'Email Address',
                        ),
                        controller: emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          return null;
                        },
                      )),
                  const Divider(
                    height: 25.0,
                  ),
                  CheckboxListTile(
                      title:
                          Text("Temple News", style: TextStyle(fontSize: 16)),
                      subtitle: Text(
                          "Information about festivals, classes, workshops, events and bimonthly temple newsletter"),
                      secondary: Icon(Icons.notifications_active),
                      isThreeLine: true,
                      value: isTempleNews,
                      onChanged: (bool newValue) =>
                          setState(() => isTempleNews = newValue)),
                  CheckboxListTile(
                      title: Text("Volunteer News",
                          style: TextStyle(fontSize: 16)),
                      subtitle: Text(
                          "Information about special volunteering opportunities"),
                      secondary: Icon(Icons.group),
                      isThreeLine: true,
                      value: isVolunteerNews,
                      onChanged: (bool newValue) =>
                          setState(() => isVolunteerNews = newValue)),
                  CheckboxListTile(
                      title: Text(
                        "Vibhuthi Saivate Immersion News",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                          "Information and alerts about registering your child(ren) for our yearly summer camp"),
                      secondary: Icon(Icons.child_care),
                      isThreeLine: true,
                      value: isVSINews,
                      onChanged: (bool newValue) =>
                          setState(() => isVSINews = newValue)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: RaisedButton(
                      onPressed: () {
                        validateEmail({
                          'email': emailController.text,
                          'firstName': firstNameController.text,
                          'lastName': lastNameController.text,
                          'interests': {
                            User.TempleNews: isTempleNews,
                            User.VolunteerNews: isVolunteerNews,
                            User.VSINews: isVSINews,
                          }
                        });
                      },
                      child: Text('Submit',
                          style: TextStyle(
                              color: Colors.amber[100], fontSize: 16)),
                      color: Colors.redAccent[700],
                    ),
                  ),
                ],
              ),
            )));
  }
}

_showDialog(BuildContext context) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Submitting form')));
}
