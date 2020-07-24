import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'contribution/create-contribution.dart';

class ListContributions extends StatefulWidget {
  @override
  _ListContributionsState createState() => _ListContributionsState();
}

class _ListContributionsState extends State<ListContributions> {
  String _groupCurrency = "Ksh";

  Future<void> _getContributionSettings(BuildContext context, String contributionId) async {
    try {
      final response = await Provider.of<Groups>(context, listen: false).getContributionDetails(contributionId);
      print(response);
      Navigator.pop(context);
      Navigator.pop(context); // pop bottom sheet
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateContribution(isEditMode: true, contributionDetails: response),
      ));
    } on CustomException catch (error) {
      Navigator.pop(context);
      Navigator.pop(context); // pop bottom sheet
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _getContributionSettings(context, contributionId);
          });
    }
  }

  void _showActions(BuildContext context, Contribution contribution) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Material(
                  color: Theme.of(context).backgroundColor,
                  child: InkWell(
                    splashColor: Colors.blueGrey.withOpacity(0.2),
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                      await _getContributionSettings(context, contribution.id);
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Colors.blueGrey,
                      ),
                      title: customTitle(
                          text: "Edit Contribution",
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                          color: Theme.of(context).textSelectionHandleColor),
                    ),
                  ),
                ),
//                Material(
//                  color: Theme.of(context).backgroundColor,
//                  child: InkWell(
//                    onTap: () {},
//                    splashColor: Colors.blueGrey.withOpacity(0.2),
//                    child: ListTile(
//                      leading: Icon(
//                        Icons.delete,
//                        color: Colors.red.withOpacity(0.7),
//                      ),
//                      title: customTitle(
//                          text: "Delete Contribution",
//                          fontWeight: FontWeight.w600,
//                          textAlign: TextAlign.start,
//                          color: Theme.of(context).textSelectionHandleColor),
//                      onTap: () {
//                        Navigator.pop(context);
//                      },
//                    ),
//                  ),
//                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _groupCurrency = Provider.of<Groups>(context, listen: false).getCurrentGroup().groupCurrency;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Contributions List",
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreateContribution(),
          ));
        },
      ),
      //backgroundColor: Theme.of(context).backgroundColor,
      backgroundColor: Colors.transparent,
      body: Builder(
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: primaryGradient(context),
              child: Consumer<Groups>(builder: (context, groupData, child) {
                return ListView.separated(
                  padding: EdgeInsets.only(bottom: 50.0, top: 10.0),
                  itemCount: groupData.contributions.length,
                  itemBuilder: (context, index) {
                    Contribution contribution = groupData.contributions[index];
                    return ListTile(
                      contentPadding: EdgeInsets.all(12.0),
                      dense: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.label,
                                  color: Colors.blueGrey,
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      heading2(
                                        text: '${contribution.name}',
                                        textAlign: TextAlign.start,
                                        color: Theme.of(context).textSelectionHandleColor,
                                      ),
                                      customTitleWithWrap(
                                        text: 'Contribution Type: ${contribution.type}',
                                        color: Theme.of(context).textSelectionHandleColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0,
                                        textAlign: TextAlign.start,
                                      ),
                                      customTitleWithWrap(
                                        text: 'Frequency: ${contribution.frequency}',
                                        color: Theme.of(context).textSelectionHandleColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0,
                                        textAlign: TextAlign.start,
                                      ),
                                      customTitle(
                                        text: '$_groupCurrency ${currencyFormat.format(double.tryParse(contribution.amount) ?? 0)}',
                                        color: Theme.of(context).textSelectionHandleColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.0,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: circleIconButton(
                              icon: Icons.edit,
                              backgroundColor: primaryColor.withOpacity(.3),
                              color: primaryColor,
                              iconSize: 16.0,
                              padding: 0.0,
                              onPressed: () => _showActions(context, contribution),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Theme.of(context).dividerColor,
                      height: 6.0,
                    );
                  },
                );
              }));
        },
      ),
    );
  }
}
