import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/settings/contribution/contribution-fines.dart';
import 'package:chamasoft/screens/chamasoft/settings/contribution/contribution-members.dart';
import 'package:chamasoft/screens/chamasoft/settings/contribution/contribution-settings.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

List<NamesListItem> daysOfMonthList = [];

class CreateContribution extends StatefulWidget {
  @override
  _CreateContributionState createState() => _CreateContributionState();
}

class _CreateContributionState extends State<CreateContribution> with SingleTickerProviderStateMixin {
  double _appBarElevation = 0;

  PageController _pageController;
  int selectedTabIndex = 0;
  int currentPage = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: secondaryPageTabbedAppbar(
          context: context,
          title: "Create Contribution",
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Builder(builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Divider(
                            thickness: 5.0,
                            indent: 10,
                            endIndent: 10,
                            color: currentPage == 0 ? primaryColor : Color(0xFFAEAEAE),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Divider(
                            thickness: 5.0,
                            indent: 10,
                            endIndent: 10,
                            color: currentPage == 1 ? primaryColor : Color(0xFFAEAEAE),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Divider(
                            thickness: 5.0,
                            indent: 10,
                            endIndent: 10,
                            color: currentPage == 2 ? primaryColor : Color(0xFFAEAEAE),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      new ContributionSettings(onButtonPressed: () {
                        if (_pageController.hasClients) {
                          _pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }

                        setState(() {
                          currentPage = 1;
                        });
                      }),
                      new ContributionMembers(onButtonPressed: () {
                        if (_pageController.hasClients) {
                          _pageController.animateToPage(
                            2,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }

                        setState(() {
                          currentPage = 2;
                        });
                      }),
                      new ContributionFineSettings(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
