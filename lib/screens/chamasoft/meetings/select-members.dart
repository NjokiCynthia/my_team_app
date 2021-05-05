import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class SelectMembers extends StatefulWidget {
  final String type;
  SelectMembers({
    @required this.type,
  });
  @override
  _SelectMembersState createState() => _SelectMembersState();
}

class _SelectMembersState extends State<SelectMembers> {
  String _title = "Select Members";
  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<CheckBoxListTileModel> checkBoxListTileModel =
      CheckBoxListTileModel.getUsers();

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  void itemChange(bool val, int index) {
    setState(() {
      checkBoxListTileModel[index].isCheck = val;
    });
  }

  String getInitials(String name) => name.isNotEmpty
      ? name.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';

  @override
  void initState() {
    if (widget.type == 'present')
      _title = "Members Present";
    else if (widget.type == 'with-apology')
      _title = "Absent With Apology";
    else if (widget.type == 'without-apology')
      _title = "Absent Without Apology";
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: _title,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                color: (themeChangeProvider.darkTheme)
                    ? Colors.blueGrey[800]
                    : Color(0xffededfe),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.lightbulb_outline,
                      color: Theme.of(context).textSelectionHandleColor,
                      size: 24.0,
                      semanticLabel: 'Select members...',
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          subtitle1(
                            text: "Select members",
                            textAlign: TextAlign.start,
                            color: Theme.of(context).textSelectionHandleColor,
                          ),
                          subtitle2(
                            text:
                                "Select the members you want to mark add and save.",
                            color: Theme.of(context).textSelectionHandleColor,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: checkBoxListTileModel.length,
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                      child: Column(
                        children: <Widget>[
                          CheckboxListTile(
                            activeColor: primaryColor,
                            isThreeLine: false,
                            dense: true,
                            title: Text(
                              checkBoxListTileModel[index].name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: checkBoxListTileModel[index].isCheck
                                    ? primaryColor
                                    : Theme.of(context)
                                        .textSelectionHandleColor,
                              ),
                            ),
                            subtitle: Text(
                              checkBoxListTileModel[index].phone,
                              style: TextStyle(
                                fontSize: 12,
                                color: checkBoxListTileModel[index].isCheck
                                    ? primaryColor
                                    : Theme.of(context)
                                        .textSelectionHandleColor,
                              ),
                            ),
                            value: checkBoxListTileModel[index].isCheck,
                            secondary: Container(
                              height: 42,
                              width: 42,
                              child: CircleAvatar(
                                foregroundColor:
                                    checkBoxListTileModel[index].isCheck
                                        ? Colors.white
                                        : (themeChangeProvider.darkTheme)
                                            ? Colors.blueGrey[900]
                                            : Colors.white,
                                backgroundColor:
                                    checkBoxListTileModel[index].isCheck
                                        ? primaryColor
                                        : Theme.of(context)
                                            .textSelectionHandleColor,
                                child: Text(
                                  getInitials(
                                    checkBoxListTileModel[index].name,
                                  ),
                                ),
                              ),
                            ),
                            onChanged: (bool val) {
                              itemChange(val, index);
                            },
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CheckBoxListTileModel {
  int userId;
  String name;
  String phone;
  bool isCheck;

  CheckBoxListTileModel({this.userId, this.name, this.phone, this.isCheck});

  static List<CheckBoxListTileModel> getUsers() {
    return <CheckBoxListTileModel>[
      CheckBoxListTileModel(
        userId: 1,
        name: "Aggrey Koros",
        phone: "254700000000",
        isCheck: false,
      ),
      CheckBoxListTileModel(
        userId: 2,
        name: "Peter Kimutai",
        phone: "254700000000",
        isCheck: false,
      ),
      CheckBoxListTileModel(
        userId: 3,
        name: "Samuel Wachira",
        phone: "254700000000",
        isCheck: false,
      ),
      CheckBoxListTileModel(
        userId: 4,
        name: "Martha Adhiambo",
        phone: "254700000000",
        isCheck: false,
      ),
      CheckBoxListTileModel(
        userId: 5,
        name: "Martin Nzuki",
        phone: "254700000000",
        isCheck: false,
      ),
    ];
  }
}
