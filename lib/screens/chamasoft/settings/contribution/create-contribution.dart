import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/settings/contribution/contribution-fines.dart';
import 'package:chamasoft/screens/chamasoft/settings/contribution/contribution-members.dart';
import 'package:chamasoft/screens/chamasoft/settings/contribution/contribution-settings.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

List<NamesListItem> daysOfMonthList = [];

class CreateContribution extends StatefulWidget {
  final bool isEditMode;
  final dynamic contributionDetails;

  CreateContribution({this.isEditMode, this.contributionDetails});

  @override
  _CreateContributionState createState() => _CreateContributionState();
}

class _CreateContributionState extends State<CreateContribution> with SingleTickerProviderStateMixin {
  double _appBarElevation = 0;
  dynamic responseData;
  PageController _pageController;
  int currentPage = 0;
  int _formEdited = 0;

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
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_formEdited);
        return new Future(() => true);
      },
      child: Scaffold(
          appBar: secondaryPageTabbedAppbar(
            context: context,
            title: widget.isEditMode == null ? "Create Contribution" : "Edit Contribution",
            action: () => Navigator.of(context).pop(_formEdited),
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
                        new ContributionSettings(
                            isEditMode: widget.isEditMode == null ? false : true,
                            contributionDetails: widget.contributionDetails,
                            onButtonPressed: (response) {
                              if (_pageController.hasClients) {
                                _pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }

                              setState(() {
                                _formEdited = 1;
                                responseData = response;
                                currentPage = 1;
                              });
                            }),
                        new ContributionMembers(
                            responseData: responseData,
                            isEditMode: widget.isEditMode == null ? false : true,
                            contributionDetails: widget.contributionDetails,
                            onButtonPressed: (response) {
                              if (_pageController.hasClients) {
                                _pageController.animateToPage(
                                  2,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }

                              setState(() {
                                responseData = response;
                                currentPage = 2;
                              });
                            }),
                        new ContributionFineSettings(
                          responseData: responseData,
                          isEditMode: widget.isEditMode == null ? false : true,
                          contributionDetails: widget.contributionDetails,
                          onButtonPressed: (response) {
                            Navigator.of(context).pop(_formEdited);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }
}
