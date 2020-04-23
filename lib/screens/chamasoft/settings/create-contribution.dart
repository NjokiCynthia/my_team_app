import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

List<NamesListItem> orderByFields = [
  NamesListItem(id: 1, name: "First Name"),
  NamesListItem(id: 2, name: "Last Name"),
  NamesListItem(id: 3, name: "Amount"),
];

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
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    .dispose();
    super.dispose();
  }

  int orderByFieldId;
  bool memberPrivacyEnabled = true;
  bool showContributionArrears = true;
  bool ignoringContributionTransfersEnabled = true;
  bool monthlyStatementsSendingEnabled = true;
  bool reducingBalanceRecalculationEnabled = true;
  int selectedTabIndex = 0;

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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
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
