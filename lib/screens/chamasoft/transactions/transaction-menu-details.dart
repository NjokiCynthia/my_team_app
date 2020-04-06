import 'package:chamasoft/screens/chamasoft/models/transaction-menu.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan-applications.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/review-withdrawal-requests.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/withdrawal-purpose.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'loans/record-loan-payment.dart';

class TransactionMenuDetails extends StatefulWidget {
  @override
  _TransactionMenuDetailsState createState() => _TransactionMenuDetailsState();
}

class _TransactionMenuDetailsState extends State<TransactionMenuDetails> {
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
    final originFlag = ModalRoute.of(context).settings.arguments;
    final List<TransactionMenu> list = [];
    String title = "Transaction";
    if (originFlag == 1) {
      title = "E-Wallet Transactions";
      list.add(TransactionMenu(
          "CREATE WITHDRAWAL REQUEST", LineAwesomeIcons.google_wallet));
      list.add(TransactionMenu(
          "REVIEW WITHDRAWAL REQUESTS", LineAwesomeIcons.file_text));
    } else if (originFlag == 2) {
      title = "Loan Transactions";
      list.add(TransactionMenu(
          "REVIEW LOAN APPLICATIONS", LineAwesomeIcons.file_text));
      list.add(TransactionMenu(
          "RECORD LOAN REPAYMENTS", LineAwesomeIcons.file_text));
    }

    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: 1,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: title,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: primaryGradient(context),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return GridView.count(
              padding: EdgeInsets.all(16.0),
              crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
              children: List.generate(list.length, (index) {
                return GridItem(
                    title: list[index].title,
                    icon: list[index].icon,
                    onTapped: () {
                      handleClickEvents(originFlag, index);
                    });
              }),
            );
          },
        ),
      ),
    );
  }

  handleClickEvents(int origin, int index) {
    switch (origin) {
      case 1:
        if (index == 0) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WithdrawalPurpose()));
        } else if (index == 1) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ReviewWithdrawalRequests()));
        }
        break;
      case 2:
        if (index == 0) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ReviewLoanApplications()));
        } else if (index == 1) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => RecordLoanPayment()));
        }
        break;
    }
  }
}
