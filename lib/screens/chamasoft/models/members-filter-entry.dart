import 'package:flutter/foundation.dart';

class MembersFilterEntry {
  MembersFilterEntry({
    @required this.name, 
    this.initials, 
    this.phoneNumber,
    @required this.memberId,
    this.amount = 0.0});
  final String name;
  final String initials;
  final String phoneNumber;
  double amount;
  final String memberId;
}
