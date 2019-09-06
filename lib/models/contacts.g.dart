// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MergeFields _$MergeFieldsFromJson(Map<String, dynamic> json) {
  return MergeFields(
      firstName: json['FNAME'] as String, lastName: json['LNAME'] as String);
}

Map<String, dynamic> _$MergeFieldsToJson(MergeFields instance) =>
    <String, dynamic>{'FNAME': instance.firstName, 'LNAME': instance.lastName};

NewContact _$NewContactFromJson(Map<String, dynamic> json) {
  return NewContact(
      emailAddress: json['email_address'] as String,
      status: json['status'] as String,
      mergeFields: json['merge_fields'] == null
          ? null
          : MergeFields.fromJson(json['merge_fields'] as Map<String, dynamic>));
}

Map<String, dynamic> _$NewContactToJson(NewContact instance) =>
    <String, dynamic>{
      'email_address': instance.emailAddress,
      'status': instance.status,
      'merge_fields': instance.mergeFields
    };
