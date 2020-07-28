import 'package:chamasoft/screens/chamasoft/models/transaction-menu.dart';
import 'package:chamasoft/screens/chamasoft/transactions/transaction-menu-details.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/utilities/svg-icons.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';

class ChamasoftTransactions extends StatefulWidget {
  ChamasoftTransactions({
    this.appBarElevation,
  });

  final ValueChanged<double> appBarElevation;

  @override
  _ChamasoftTransactionsState createState() => _ChamasoftTransactionsState();
}

class _ChamasoftTransactionsState extends State<ChamasoftTransactions> {
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
    final List<TransactionMenuSvg> list = [
      TransactionMenuSvg("E-WALLET", customIcons['wallet']),
      // TransactionMenuSvg("LOANS", customIcons['transaction']),
      TransactionMenuSvg("RECORD PAYMENTS", customIcons['invoice']),
      TransactionMenuSvg("RECORD EXPENDITURE", customIcons['expense']),
      TransactionMenuSvg("INVOICING & TRANSFER", customIcons['transaction']),
    ];

    return new WillPopScope(
      onWillPop: _onWillPop ,
      child: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
            crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
            children: List.generate(list.length, (index) {
              return svgGridButton(
                context: context,
                icon: list[index].icon,
                title: list[index].title,
                color: (index == 0) ? Colors.white : Colors.blue[400],
                isHighlighted: (index == 0) ? true : false,
                action: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => TransactionMenuDetails(),
                    settings: RouteSettings(arguments: index)
                  )
                ),
                margin: 12
              );
            }),
          );
        },
      )
    );
  }
}