class MembersFilterEntry {
  MembersFilterEntry(this.name, this.initials, this.phoneNumber,
      {this.amount = 0.0});
  final String name;
  final String initials;
  final String phoneNumber;
  double amount;
}
