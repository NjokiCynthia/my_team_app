import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class FilterContainer extends StatefulWidget {
  @override
  _FilterContainerState createState() => _FilterContainerState();
}

class _FilterContainerState extends State<FilterContainer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _selectAll = false;
  bool _contributionPayments = false;
  bool _showStatusFilter = true;
  bool _showMemberFilter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: tertiaryPageAppbar(
          context: context,
          title: "Filter By",
          action: () => Navigator.of(context).pop(),
          elevation: 1,
          leadingIcon: LineAwesomeIcons.close,
          trailingIcon: LineAwesomeIcons.check,
          trailingAction: () {}),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        width: double.infinity,
        child: Row(
          children: [
            Container(
              color: themeChangeProvider.darkTheme ? Colors.grey[800] : Colors.grey[100],
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    child: Material(
                      color: themeChangeProvider.darkTheme ? Colors.grey[800] : Colors.grey[100],
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _showMemberFilter = false;
                            _showStatusFilter = true;
                          });
                        },
                        splashColor: Colors.blueGrey.withOpacity(0.2),
                        child: Row(
                          children: [
                            subtitle1(
                                text: "Status",
                                textAlign: TextAlign.start,
                                color: Theme.of(context).textSelectionHandleColor),
                            Visibility(
                                visible: _showStatusFilter,
                                child: Icon(LineAwesomeIcons.chevron_right,
                                    size: 16, color: Theme.of(context).textSelectionHandleColor))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: Material(
                      color: themeChangeProvider.darkTheme ? Colors.grey[800] : Colors.grey[100],
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _showMemberFilter = true;
                            _showStatusFilter = false;
                          });
                        },
                        splashColor: Colors.blueGrey.withOpacity(0.2),
                        child: Row(
                          children: [
                            subtitle1(
                                text: "Members",
                                textAlign: TextAlign.start,
                                color: Theme.of(context).textSelectionHandleColor),
                            Visibility(
                                visible: _showMemberFilter,
                                child: Icon(LineAwesomeIcons.chevron_right,
                                    size: 16, color: Theme.of(context).textSelectionHandleColor))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: subtitle1(
                          text: "Select All",
                          textAlign: TextAlign.start,
                          color: Theme.of(context).textSelectionHandleColor),
                      value: _selectAll,
                      onChanged: (value) {
                        setState(() {
                          _selectAll = value;
                        });
                      },
                      activeColor: primaryColor,
                    ),
                    CheckboxListTile(
                      title: subtitle1(
                          text: "Contribution Payments",
                          textAlign: TextAlign.start,
                          color: Theme.of(context).textSelectionHandleColor),
                      value: _contributionPayments,
                      onChanged: (value) {
                        setState(() {
                          _contributionPayments = value;
                        });
                      },
                      activeColor: primaryColor,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
