import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/models/report-menu.dart';
import 'package:chamasoft/screens/chamasoft/reports/deposit-receipts.dart';
import 'package:chamasoft/screens/chamasoft/reports/group-reports-menu.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/contribution-statement.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/loan-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/withdrawal_receipts.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/svg-icons.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';

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
    await Navigator.of(context).pushReplacementNamed(ChamasoftDashboard.namedRoute);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final List<ReportMenuSvg> list = [
      ReportMenuSvg("CONTRIBUTION", "STATEMENT", customIcons['transaction']),
      ReportMenuSvg("FINE", "STATEMENT", customIcons['invoice']),
      //ReportMenuSvg("LOAN", "APPLICATIONS", customIcons['refund']),
      ReportMenuSvg("LOAN", "SUMMARY", customIcons['expense']),
      ReportMenuSvg("DEPOSIT", "RECEIPTS", customIcons['cash-in-hand']),
      ReportMenuSvg("WITHDRAWAL", "RECEIPTS", customIcons['cash-register']),
      ReportMenuSvg("MORE GROUP", "REPORTS", customIcons['group']),
    ];

    return new WillPopScope(
        onWillPop: _onWillPop,
        child: OrientationBuilder(
          builder: (context, orientation) {
            return GridView.count(
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
              crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
              children: List.generate(list.length, (index) {
                ReportMenuSvg menu = list[index];
                return svgGridButton(
                    context: context,
                    icon: menu.icon,
                    title: menu.title,
                    subtitle: menu.subtitle,
                    color: (index == list.length - 1) ? Colors.white : Colors.blue[400],
                    isHighlighted: (index == list.length - 1) ? true : false,
                    action: () => navigate(index),
                    margin: 12);
              }),
            );
          },
        ));
  }

  void navigate(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return ContributionStatement(
                statementFlag: CONTRIBUTION_STATEMENT,
              );
            },
            settings: RouteSettings(arguments: index + 1)));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return ContributionStatement(
                statementFlag: FINE_STATEMENT,
              );
            },
            settings: RouteSettings(arguments: index + 1)));
        break;
//      case 2:
//        Navigator.of(context).push(MaterialPageRoute(
//            builder: (BuildContext context) {
//              return LoanApplications();
//            },
//            settings: RouteSettings(arguments: index + 1)));
//        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return LoanSummary();
            },
            settings: RouteSettings(arguments: index + 1)));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return DepositReceipts();
            },
            settings: RouteSettings(arguments: index + 1)));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return WithdrawalReceipts();
            },
            settings: RouteSettings(arguments: index + 1)));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return GroupReportsMenu();
            },
            settings: RouteSettings(arguments: index + 1)));
        break;
    }
  }
}
