import 'package:flutter/material.dart';

class Meeting {
  final String groupId;
  final String title;
  final String venue;
  final String purpose;
  final String date;
  final Map<String, dynamic> members;
  final List<String> agenda;
  final Map<String, dynamic> collections;
  final List<String> aob;
  final int synced;

  Meeting({
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
