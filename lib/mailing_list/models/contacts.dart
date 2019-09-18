import 'package:json_annotation/json_annotation.dart';
import '../services/mailChimpAPI.dart';

part 'contacts.g.dart';

@JsonSerializable()
class MergeFields {
  @JsonKey(name: 'FNAME')
  String firstName;
  @JsonKey(name: 'LNAME')
  String lastName;

  MergeFields({this.firstName, this.lastName});

  factory MergeFields.fromJson(Map<String, dynamic> json) => _$MergeFieldsFromJson(json);

  Map<String, dynamic> toJson() => _$MergeFieldsToJson(this);
}

@JsonSerializable()
class NewContact {
  @JsonKey(name: 'email_address')
  String emailAddress;
  String status;
  @JsonKey(name: 'merge_fields')
  MergeFields mergeFields;

  NewContact({this.emailAddress, this.status, this.mergeFields});

  factory NewContact.fromJson(Map<String, dynamic> json) => _$NewContactFromJson(json);

  Map<String, dynamic> toJson() => _$NewContactToJson(this);
}


class User {

  static const String TempleNews = 'temple';
  static const String VolunteerNews = 'volunteer';
  static const String VSINews = 'vsi';

  String email;
  String fName;
  String lName;

  Map mailingLists = {
    TempleNews: false,
    VolunteerNews: false,
    VSINews: false
  };

  save() async {
    NewContact contact = NewContact(emailAddress: email, status: 'subscribed', mergeFields: MergeFields(firstName: fName, lastName: lName));
    print('Saving user information');
    String added = await addContact(contact);
    print(added);
  }

}