import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

List<NamesListItem> frequenciesList = [
  NamesListItem(id: 1, name: "Regular"),
  NamesListItem(id: 2, name: "One Time"),
  NamesListItem(id: 3, name: "Irregular"),
];

List<NamesListItem> daysOfMonthList = [];

class CreateContribution extends StatefulWidget {
  @override
  _CreateContributionState createState() => _CreateContributionState();
}

class _CreateContributionState extends State<CreateContribution>
    with SingleTickerProviderStateMixin {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  List<MembersFilterEntry> selectedMembersList = [];
  int memberTypeId;
  TabController _tabController;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(vsync: this, length: 3);
    String trail;
    daysOfMonthList.clear();
    for (int i = 1; i <= 31; i++) {
      trail = 'th';
      if (i % 10 == 1 && i != 11) {
        trail = 'st';
      } else if (i % 10 == 2 && i != 12) {
        trail = 'nd';
      } else if (i % 10 == 3 && i != 13) {
        trail = 'rd';
      }
      setState(() {
        daysOfMonthList.add(NamesListItem(id: i, name: "Every $i$trail"));
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  int selectedTabIndex = 0;
  int frequencyId;
  int dayOfMonthId;
  double contributionAmount = 0;
  String contributionName = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: secondaryPageTabbedAppbar(
          context: context,
          title: "Create Contribution",
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          bottom: TabBar(
            controller: _tabController,
            onTap: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(
                child: Divider(
                  thickness: 5.0,
                  color:
                      selectedTabIndex == 0 ? primaryColor : Color(0xFFAEAEAE),
                ),
              ),
              Tab(
                child: Divider(
                  thickness: 5.0,
                  color:
                      selectedTabIndex == 1 ? primaryColor : Color(0xFFAEAEAE),
                ),
              ),
              Tab(
                child: Divider(
                  thickness: 5.0,
                  color:
                      selectedTabIndex == 2 ? primaryColor : Color(0xFFAEAEAE),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Settings",
                      style: TextStyle(
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "Configure the behaviour of your contribution",
                      style:
                          TextStyle(color: Theme.of(context).bottomAppBarColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomDropDownButton(
                            labelText: "Select Frequency",
                            listItems: frequenciesList,
                            selectedItem: frequencyId,
                            onChanged: (value) {
                              setState(() {
                                frequencyId = value;
                              });
                            },
                          ),
                          CustomDropDownButton(
                            labelText: "Select Day of Month",
                            listItems: daysOfMonthList,
                            selectedItem: dayOfMonthId,
                            onChanged: (value) {
                              setState(() {
                                dayOfMonthId = value;
                              });
                            },
                          ),
                          simpleTextInputField(
                            context: context,
                            labelText: 'Contribution Name',
                            hintText: 'Monthly Contributions'.toUpperCase(),
                            onChanged: (value) {
                              setState(() {
                                contributionName = value;
                              });
                            },
                          ),
                          amountTextInputField(
                            context: context,
                            labelText: 'Contribution Amount',
                            hintText: '1,500',
                            onChanged: (value) {
                              setState(() {
                                contributionAmount = double.parse(value);
                              });
                            },
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "Members",
                          style: TextStyle(
                              color: Theme.of(context).textSelectionHandleColor,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "Select members who will contribute",
                          style: TextStyle(
                              color: Theme.of(context).bottomAppBarColor),
                        ),
                      ),
                    ]),
              ),
            ),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "Fines",
                          style: TextStyle(
                              color: Theme.of(context).textSelectionHandleColor,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "Select Fines for Late Members",
                          style: TextStyle(
                              color: Theme.of(context).bottomAppBarColor),
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
