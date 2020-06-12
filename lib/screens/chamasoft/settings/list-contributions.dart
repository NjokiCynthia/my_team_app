import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'create-contribution.dart';

class ListContributions extends StatefulWidget {
  @override
  _ListContributionsState createState() => _ListContributionsState();
}

class _ListContributionsState extends State<ListContributions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: primaryGradient(context),
          child: Consumer<Groups>(builder: (context, groupData, child) {
            return ListView.separated(
              padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
              itemCount: groupData.contributions.length,
              itemBuilder: (context, index) {
                Contribution contribution = groupData.contributions[index];
                return ListTile(
                  dense: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.label,
                                  color: Colors.blueGrey,
                                ),
                                SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${contribution.name}',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textSelectionHandleColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Contribution Type: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .textSelectionHandleColor
                                                    .withOpacity(0.5),
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            Text(
                                              '${contribution.type}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                color: Theme.of(context)
                                                    .textSelectionHandleColor
                                                    .withOpacity(0.5),
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Frequency: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .textSelectionHandleColor
                                                    .withOpacity(0.5),
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${contribution.frequency}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: Theme.of(context)
                                                .textSelectionHandleColor
                                                .withOpacity(0.5),
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                smallBadgeButton(
                                  backgroundColor:
                                      primaryColor.withOpacity(0.2),
                                  textColor: primaryColor,
                                  text: '${contribution.amount}',
                                  action: () {},
                                  buttonHeight: 24.0,
                                  textSize: 12.0,
                                ),
                              ],
                            )
                          ],
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
          })),
    );
  }
}
