import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:contacts_service/contacts_service.dart';

class CustomContact {
  Contact contact;
  GroupRoles role;
  SimpleContact simpleContact;

  CustomContact({this.contact, this.role});

  CustomContact.simpleContact({this.simpleContact, this.role});
}

class SimpleContact {
  String firstName, lastName;
  String phoneNumber, email;

  SimpleContact({this.firstName, this.lastName, this.phoneNumber, this.email});
}
