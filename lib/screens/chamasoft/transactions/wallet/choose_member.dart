// ignore_for_file: unused_element, duplicate_ignore

import 'dart:async';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/custom-contact.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/amount-to-withdraw.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/contact_list.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/member_phone.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
//import 'amount-to-withdraw.dart';

class ListMemberContacts extends StatefulWidget {
  final Map<String, String> formData;
  final String groupId;
  final Map<String, dynamic> formLoadData;
  const ListMemberContacts(
      {Key key, this.formLoadData, this.formData, this.groupId})
      : super(key: key);

  @override
  State<ListMemberContacts> createState() => _ListMemberContactsState();
}

class _ListMemberContactsState extends State<ListMemberContacts> {
  // TextEditingController _controller = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  StreamSubscription<Iterable<Contact>> contactSubscriber;
  String filter;
  int count = 0;

  final Permission _permission = Permission.contacts;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  // undetermined
 
  //List<CustomContact> _contacts = new List<CustomContact>();
  List<CustomContact> _contacts = <CustomContact>[];

  bool _isLoading = false;
  String floatingButtonLabel;
  Color floatingButtonColor;
  IconData icon;
  Contact selectedContact;

  // ignore: unused_field
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // List<GroupMemberDetail> _member = [];
  List<Member> _member = [];
  bool _hasMoreData = false;
  Member member;
  TextEditingController controller = new TextEditingController();
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isInit = true;

  // _ListMemberContactsState({
  //   this.floatingButtonLabel,
  //   this.icon,
  //   this.floatingButtonColor,
  // });

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() {
      _permissionStatus = status;
      if (_permissionStatus == PermissionStatus.granted) {
        contactSubscriber = refreshContacts().asStream().listen((contacts) {
          _populateContacts(contacts);
        });
      } else {
        requestPermission();
      }
    });
  }

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  /*Future<void> _fetchMembers(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .getGroupMembersDetails(widget.groupId);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchMembers(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }*/

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    /*_fetchMembers(context).then((_) {
      if (context != null) {
        setState(() {
          if (_member.length < 20) {
            _hasMoreData = false;
          } else
            _hasMoreData = true;
          _isLoading = false;
        });
      }
    });*/

    _isInit = false;
    return true;
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _listenForPermissionStatus();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    _phoneController.dispose();
    contactSubscriber.cancel();
    controller.dispose();
    super.dispose();
  }

  String _getOptionName(int id, List<NamesListItem> list) {
    var name = '';
    for (final item in list) {
      if (id == item.id) {
        name = item.name;
      }
    }
    return name;
  }

  // ignore: unused_element
  void _numberPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: heading2(
              text: "Set Recipient Contact",
             
              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
              textAlign: TextAlign.start),
          content: TextFormField(
            controller: _phoneController,
            style: inputTextStyle(),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
             
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 1.0,
              )),
              // hintText: 'Phone Number or Email Address',
              labelText: "Enter Phone Number",
            ),
          ),
          actions: <Widget>[
            negativeActionDialogButton(
                text: "Cancel",
               
                color:
                    Theme.of(context).textSelectionTheme.selectionHandleColor,
                action: () {
                  Navigator.of(context).pop();
                }),
            positiveActionDialogButton(
                text: "Continue",
                color: primaryColor,
                action: () {
                  print("Phone: ${_phoneController.text}");
                  if (CustomHelper.validPhone(_phoneController.text)) {
                    Navigator.of(context).pop();
                    // _proceedToAmountPage(2);
                  }
                })
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _member = Provider.of<Groups>(context, listen: true)
        .members /*groupMembersDetails*/;
    return Scaffold(
        appBar: tertiaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: 2.5,
          leadingIcon: LineAwesomeIcons.times,
          title: "Select Recipient",
          /*  trailingIcon: LineAwesomeIcons.user_plus,
          trailingAction: () => _numberPrompt() */
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        /*  floatingActionButton: FloatingActionButton(
          child: Icon(
            LineAwesomeIcons.user_plus,
            color: Colors.white,
          ),
          backgroundColor: primaryColor,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  NumberKeyBoard())) /* _numberPrompt() */
          ), */
        body: /*!_isLoading
          ?*/
            Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 5.0,
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Search Contact",
                  prefixIcon: Icon(LineAwesomeIcons.search),
                ),
                controller: controller,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Enter Contact",
                      style: TextStyle(
                        color: Colors.blueGrey[400],
                        fontFamily: 'SegoeUI',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Feather.more_horizontal,
                        color: Colors.blueGrey,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Icon(Feather.phone, size: 15, color: Colors.white),
                ),
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          NumberKeyBoard(formData: widget.formData)));
                },
                title: subtitle1(
                    text: 'ENTER PHONE NUMBER', textAlign: TextAlign.start),
              ),
              SizedBox(
                height: 8.0,
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Icon(Feather.list, size: 15, color: Colors.white),
                ),
                onTap: () async {
                  await /* Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              NumberKeyBoard(formData: widget.formData)));

                                */
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ContactList(formData: widget.formData

                                  // member: member,
                                  )));
                },
                title: subtitle1(
                    text: 'SELECT FROM CONTACT', textAlign: TextAlign.start),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Select Member Contact",
                      style: TextStyle(
                        color: Colors.blueGrey[400],
                        fontFamily: 'SegoeUI',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Feather.more_horizontal,
                        color: Colors.blueGrey,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!_isLoading &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      _hasMoreData) {
                    _fetchData();
                  }
                  return true;
                },
                child: ListView.builder(
                  // padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    Member member = _member[index];

                    return filter == null || filter == ""
                        ? _memberList(member, widget.formData)
                        : member.name
                                .toLowerCase()
                                .contains(filter.toLowerCase())
                            ? _memberList(member, widget.formData)
                            : Visibility(
                                visible: false, child: new Container());
                  },
                  itemCount: _member.length,
                ),
              )),
              /*   Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Select From your Contacts",
                          style: TextStyle(
                            color: Colors.blueGrey[400],
                            fontFamily: 'SegoeUI',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Feather.more_horizontal,
                            color: Colors.blueGrey,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ), */
              /*   Expanded(
                    child: ListView.builder(
                      itemCount: _contacts?.length,
                      itemBuilder: (context, index) {
                        Contact _contact = _contacts[index].contact;
                        String displayName = _contact.displayName;
                        var _phonesList = _contact.phones.toList();
                        String filterContacts = filter;

                        return filterContacts == null || filterContacts == ""
                            ? _buildListTile(index, _contact, _phonesList)
                            : displayName
                                    .toLowerCase()
                                    .contains(filterContacts.toLowerCase())
                                ? _buildListTile(index, _contact, _phonesList)
                                : Visibility(
                                    visible: false, child: new Container());
                      },
                      // itemBuilder: (BuildContext context, int index) {
                      //   Contact _contact = _contacts[index].contact;
                      //   String displayName = _contact.displayName;
                      //   var _phonesList = _contact.phones.toList();

                      //   return filter == null || filter == ""
                      //       ? _buildListTile(index, _contact, _phonesList)
                      //       : displayName
                      //               .toLowerCase()
                      //               .contains(filter.toLowerCase())
                      //           ? _buildListTile(index, _contact, _phonesList)
                      //           : Visibility(
                      //               visible: false, child: new Container());
                      // },
                    ),
                  ), */
            ],
          ),
        )
        /*: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  subtitle1(text: "Retrieving Member list")
                ],
              ),
            ),*/
        );
  }

  Future<void> requestPermission() async {
    final status = await Permission.contacts.request();

    setState(() {
      _permissionStatus = status;

      if (_permissionStatus.isGranted) {
        contactSubscriber = refreshContacts().asStream().listen((contacts) {
          _populateContacts(contacts);
        });
      } else {}
    });
  }

  // ignore: unused_element
  ListTile _buildListTile(int index, Contact contact, List<Item> list) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor:
              primaryColor, //Colors.primaries[Random().nextInt(Colors.primaries.length)],
          child: Text(contact.displayName[0].toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 24))),
      onTap: () async {
        // selectedContact = contact;
        // _proceedToAmountPage(1);
        widget.formData['phone'] = list[0].value;

        await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AmountToWithdraw(
                  formData: widget.formData,
                  // member: member,
                )));
      },
      title: subtitle1(
          text: contact.displayName ?? "", textAlign: TextAlign.start),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? subtitle1(text: list[0].value, textAlign: TextAlign.start)
          : Text(''),
    );
  }

  Future<Iterable<Contact>> refreshContacts() async {
    setState(() {
      _isLoading = true;
    });
    var contacts = await ContactsService.getContacts(withThumbnails: false);
    return contacts;
  }

  void _populateContacts(Iterable<Contact> contacts) {
    for (Contact contact in contacts) {
      if (contact.phones.length > 0) {
        _contacts.add(CustomContact(contact: contact));
      }
    }

    setState(() {
      _contacts.sort(
          (a, b) => a.contact.displayName.compareTo(b.contact.displayName));
      _isLoading = false;
    });
  }

  _memberList(Member member, Map<String, String> formData) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: primaryColor,
          child: Text(member.name[0].toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 24))),
      onTap: () async {
        widget.formData['phone'] = member.phone;
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AmountToWithdraw(
                  // member: member,
                  formData: widget.formData,
                )));
      },
      title: subtitle1(text: member.name ?? "", textAlign: TextAlign.start),
      subtitle: subtitle1(text: member.phone ?? "", textAlign: TextAlign.start),
    );
  }
}
