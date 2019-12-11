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
  @JsonKey(name: 'merge_fields')
  MergeFields mergeFields;

  Map<String, bool> interests;

  String status = "subscribed";

  NewContact({this.emailAddress, this.mergeFields, this.interests});

  factory NewContact.fromJson(Map<String, dynamic> json) => _$NewContactFromJson(json);

  Map<String, dynamic> toJson() => _$NewContactToJson(this);
}


class User {
  static const String TempleNews = 'ca903fe669';
  static const String VolunteerNews = '32c1cd062c';
  static const String VSINews = '32936e01ff';

  String email;
  String fName;
  String lName;
}