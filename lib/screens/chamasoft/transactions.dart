import 'package:chamasoft/screens/chamasoft/models/transaction-menu.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan-applications.dart';
import 'package:chamasoft/screens/chamasoft/transactions/transaction-menu-detaills.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/withdrawal-purpose.dart';
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

  @override
  Widget build(BuildContext context) {
    final List<TransactionMenu> list = [
      TransactionMenu("E-WALLET", LineAwesomeIcons.google_wallet),
      TransactionMenu("LOANS", LineAwesomeIcons.money),
    ];

    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.count(
          padding: EdgeInsets.all(16.0),
          crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
          children: List.generate(list.length, (index) {
            return GridItem(
                title: list[index].title,
                icon: list[index].icon,
                onTapped: () {
                  if (index == 0) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            TransactionMenuDetails(),
                        settings: RouteSettings(arguments: 1)));
                  } else if (index == 1) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            TransactionMenuDetails(),
                        settings: RouteSettings(arguments: 2)));
                  }
                });
          }),
        );
      },
    );
  }
}
