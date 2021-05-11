import 'package:flutter/material.dart';

class MeetingModel {
  String groupId;
  String title;
  String venue;
  String purpose;
  String date;
  Map<String, dynamic> members;
  List<String> agenda;
  Map<String, dynamic> collections;
  List<String> aob;
  int synced;

  MeetingModel({
    @required this.groupId,
    @required this.title,
    @required this.venue,
    this.purpose,
    @required this.date,
    @required this.members,
    @required this.agenda,
    this.collections,
    this.aob,
    @required this.synced,
  });
}
