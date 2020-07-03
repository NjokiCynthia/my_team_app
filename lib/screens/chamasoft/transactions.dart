import 'package:chamasoft/screens/chamasoft/models/transaction-menu.dart';
import 'package:chamasoft/screens/chamasoft/transactions/transaction-menu-details.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class ChamasoftTransactions extends StatefulWidget {
  @override
  _ChamasoftTransactionsState createState() => _ChamasoftTransactionsState();
}

class _ChamasoftTransactionsState extends State<ChamasoftTransactions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context).pushReplacementNamed(ChamasoftDashboard.namedRoute);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final List<TransactionMenu> list = [
      TransactionMenu("E-WALLET", LineAwesomeIcons.google_wallet),
      TransactionMenu("LOANS", LineAwesomeIcons.file_text),
      TransactionMenu("RECORD PAYMENTS", LineAwesomeIcons.bar_chart_o),
      TransactionMenu("RECORD EXPENDITURE", LineAwesomeIcons.pie_chart),
      TransactionMenu("INVOICING & TRANSFER", LineAwesomeIcons.send),
    ];

    return new WillPopScope(
      onWillPop: _onWillPop ,
      child: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(
            padding: EdgeInsets.all(12.0),
            crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
            children: List.generate(list.length, (index) {
              return gridButton(
                context: context,
                icon: list[index].icon,
                title: list[index].title,
                color: (index == 0) ? Colors.white : Colors.blue[400],
                isHighlighted: (index == 0) ? true : false,
                action: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => TransactionMenuDetails(),
                    settings: RouteSettings(arguments: index))),
              );
            }),
          );
        },
      )
    );
  }
}
