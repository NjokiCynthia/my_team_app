import 'package:chamasoft/screens/chamasoft/models/report-menu.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/contribution-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/expense-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/group-loans-summary.dart';
import 'package:chamasoft/screens/chamasoft/reports/group/transaction-statement.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/svg-icons.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'group/account-balances.dart';

class GroupReportsMenu extends StatefulWidget {
  @override
  _GroupReportsMenuState createState() => _GroupReportsMenuState();
}

class _GroupReportsMenuState extends State<GroupReportsMenu> {
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
    final List<ReportMenuSvg> list = [
      ReportMenuSvg("ACCOUNT", "BALANCES", customIcons['bank-cards']),
      ReportMenuSvg("CONTRIBUTION", "SUMMARY", customIcons['money-bag']),
      ReportMenuSvg("FINE", "SUMMARY", customIcons['expense']),
      ReportMenuSvg("LOAN", "SUMMARY", customIcons['transaction']),
      //ReportMenuSvg("LOAN", "APPLICATIONS", customIcons['refund']),
      ReportMenuSvg("EXPENSE", "SUMMARY", customIcons['card-payment']),
      ReportMenuSvg("TRANSACTION", "STATEMENT", customIcons['invoice']),
    ];
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: 1,
        leadingIcon: LineAwesomeIcons.close,
        title: "Group Reports",
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: primaryGradient(context),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return GridView.count(
              padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
              crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
              children: List.generate(list.length, (index) {
                ReportMenuSvg menu = list[index];
                return svgGridButton(
                    context: context,
                    icon: menu.icon,
                    title: menu.title,
                    subtitle: menu.subtitle,
                    color: Colors.blue[400],
                    isHighlighted: false,
                    action: () => navigate(index),
                    margin: 12);
              }),
            );
          },
        ),
      ),
    );
  }

  void navigate(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return AccountBalances();
        }));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return ContributionSummary();
            },
            settings: RouteSettings(arguments: CONTRIBUTION_STATEMENT)));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return ContributionSummary();
            },
            settings: RouteSettings(arguments: FINE_STATEMENT)));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return GroupLoansSummary();
        }));
        break;
//      case 4:
//        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
//          return GroupLoanApplications();
//        }));
//        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return ExpenseSummary();
        }));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return TransactionStatement();
        }));
    }
  }
}
