import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/reports/deposit-receipts.dart';
import 'package:chamasoft/screens/chamasoft/reports/member-statement.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/contribution-statement.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/loan-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/withdrawal_receipts.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/svg-icons.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/contribution-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/expense-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/group-loans-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/transaction-statement.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/account-balances.dart';
import 'package:provider/provider.dart';

class ChamasoftReports extends StatefulWidget {
  ChamasoftReports({
    this.appBarElevation,
  });

  final ValueChanged<double> appBarElevation;

  @override
  _ChamasoftReportsState createState() => _ChamasoftReportsState();
}

class _ChamasoftReportsState extends State<ChamasoftReports> {
  ScrollController _scrollController;

  void _scrollListener() {
    widget.appBarElevation(_scrollController.offset);
  }

  @override
  void initState() {
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

  Future<bool> _onWillPop() async {
    await Navigator.of(context)
        .pushReplacementNamed(ChamasoftDashboard.namedRoute);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<Groups>(context, listen: false).getCurrentGroup();
    List<Widget> memberOptions = [
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['transaction'],
              title: 'CONTRIBUTION',
              subtitle: 'STATEMENT',
              color: Colors.white,
              //Colors.blue[400],
              isHighlighted: true,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ContributionStatement(
                      statementFlag: CONTRIBUTION_STATEMENT),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['invoice'],
              title: 'FINE',
              subtitle: 'STATEMENT',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ContributionStatement(statementFlag: FINE_STATEMENT),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['expense'],
              title: 'LOAN',
              subtitle: 'SUMMARY',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => LoanSummary(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
    ];

    List<Widget> transactionOptions = [
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['cash-in-hand'],
              title: 'DEPOSIT',
              subtitle: 'RECEIPTS',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => DepositReceipts(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['cash-register'],
              title: 'WITHDRAWAL',
              subtitle: 'RECEIPTS',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WithdrawalReceipts(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
    ];

    List<Widget> statementOptions = [
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['transaction'],
              title: 'MEMBER',
              subtitle: 'STATEMENTS',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MemeberSatement(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
    ];

    List<Widget> groupOptions = [
      SizedBox(
        width: 16.0,
      ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['bank-cards'],
              title: 'ACCOUNT',
              subtitle: 'BALANCES',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AccountBalances(),
                  settings: RouteSettings(arguments: 0))),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
        Container(
            width: 132.0,
            child: svgGridButton(
                context: context,
                icon: customIcons['money-bag'],
                title: 'CONTRIBUTION',
                subtitle: 'SUMMARY',
                color: Colors.blue[400],
                isHighlighted: false,
                action: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ContributionSummary(),
                    settings:
                        RouteSettings(arguments: CONTRIBUTION_STATEMENT))),
                margin: 0,
                imageHeight: 100.0)),
      if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
        SizedBox(
          width: 16.0,
        ),
      if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
        Container(
            width: 132.0,
            child: svgGridButton(
                context: context,
                icon: customIcons['expense'],
                title: 'FINE',
                subtitle: 'SUMMARY',
                color: Colors.blue[400],
                isHighlighted: false,
                action: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ContributionSummary(),
                    settings: RouteSettings(arguments: FINE_STATEMENT))),
                margin: 0,
                imageHeight: 100.0)),
      if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
        SizedBox(
          width: 16.0,
        ),
      if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
        Container(
            width: 132.0,
            child: svgGridButton(
                context: context,
                icon: customIcons['transaction'],
                title: 'LOAN',
                subtitle: 'SUMMARY',
                color: Colors.blue[400],
                isHighlighted: false,
                action: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => GroupLoansSummary())),
                margin: 0,
                imageHeight: 100.0)),
      if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
        SizedBox(
          width: 16.0,
        ),
      Container(
          width: 132.0,
          child: svgGridButton(
              context: context,
              icon: customIcons['card-payment'],
              title: 'EXPENSE',
              subtitle: 'SUMMARY',
              color: Colors.blue[400],
              isHighlighted: false,
              action: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ExpenseSummary())),
              margin: 0,
              imageHeight: 100.0)),
      SizedBox(
        width: 16.0,
      ),
      if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
        Container(
            width: 132.0,
            child: svgGridButton(
                context: context,
                icon: customIcons['invoice'],
                title: 'TRANSACTION',
                subtitle: 'STATEMENT',
                color: Colors.blue[400],
                isHighlighted: false,
                action: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => TransactionStatement())),
                margin: 0,
                imageHeight: 100.0)),
      if (!group.enableMemberInformationPrivacy || group.isGroupAdmin)
        SizedBox(
          width: 16.0,
        ),
    ];

    return new WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
            child: SingleChildScrollView(
                // controller: _scrollController,
                child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Your Reports",
                  style: TextStyle(
                    color: Colors.blueGrey[400],
                    fontFamily: 'SegoeUI',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Feather.more_horizontal,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {})
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Container(
              height: 160.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                physics: BouncingScrollPhysics(),
                children: memberOptions,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Transaction Reports",
                  style: TextStyle(
                    color: Colors.blueGrey[400],
                    fontFamily: 'SegoeUI',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Feather.more_horizontal,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {})
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Container(
              height: 160.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                physics: BouncingScrollPhysics(),
                children: transactionOptions,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Group Reports",
                  style: TextStyle(
                    color: Colors.blueGrey[400],
                    fontFamily: 'SegoeUI',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Feather.more_horizontal,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {})
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
            child: Container(
              height: 160.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                physics: BouncingScrollPhysics(),
                children: groupOptions,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Statements",
                  style: TextStyle(
                    color: Colors.blueGrey[400],
                    fontFamily: 'SegoeUI',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Feather.more_horizontal,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {})
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
            child: Container(
              height: 160.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                physics: BouncingScrollPhysics(),
                children: statementOptions,
              ),
            ),
          ),
        ])))
        // child: OrientationBuilder(
        //   builder: (context, orientation) {
        //     return GridView.count(
        //       controller: _scrollController,
        //       padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
        //       crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
        //       children: List.generate(list.length, (index) {
        //         ReportMenuSvg menu = list[index];
        //         return svgGridButton(
        //             context: context,
        //             icon: menu.icon,
        //             title: menu.title,
        //             subtitle: menu.subtitle,
        //             color: (index == list.length - 1) ? Colors.white : Colors.blue[400],
        //             isHighlighted: (index == list.length - 1) ? true : false,
        //             action: () => navigate(index),
        //             margin: 12);
        //       }),
        //     );
        //   },
        // )
        );
  }
}
