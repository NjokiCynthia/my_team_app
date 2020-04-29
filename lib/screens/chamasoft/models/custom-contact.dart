import 'package:chamasoft/screens/chamasoft/models/member-role.dart';
import 'package:contacts_service/contacts_service.dart';

class CustomContact {
  Contact contact;
  MemberRole role = MemberRole(id: 0, name: "Member");

  CustomContact({this.contact, this.role});
}
