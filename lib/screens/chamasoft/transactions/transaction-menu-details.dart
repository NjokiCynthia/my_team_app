import 'package:chamasoft/screens/chamasoft/models/transaction-menu.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-contribution-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-fine-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/review-loan-applications.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/review-withdrawal-requests.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/withdrawal-purpose.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'expenditure/bank-loan-repayments.dart';
import 'expenditure/record-contribution-refund.dart';
import 'expenditure/record-expense.dart';
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

    switch (originFlag) {
      case 0:
        title = "E-Wallet Transactions";
        list.add(TransactionMenu(
            "CREATE WITHDRAWAL REQUEST", LineAwesomeIcons.google_wallet));
        list.add(TransactionMenu(
            "REVIEW WITHDRAWAL REQUESTS", LineAwesomeIcons.file_text));
        break;
      case 1:
        title = "Loan Transactions";
        list.add(TransactionMenu(
            "REVIEW LOAN APPLICATIONS", LineAwesomeIcons.file_text));
        list.add(TransactionMenu(
            "RECORD LOAN REPAYMENTS", LineAwesomeIcons.file_text));
        break;
      case 2:
        title = "Record Payments";
        list.add(TransactionMenu("CONTRIBUTIONS", LineAwesomeIcons.file_text));
        list.add(TransactionMenu("FINES", LineAwesomeIcons.file_text));
        list.add(TransactionMenu("INCOME", LineAwesomeIcons.file_text));
        list.add(TransactionMenu("MISCELLANEOUS", LineAwesomeIcons.file_text));
        list.add(TransactionMenu("BANK LOANS", LineAwesomeIcons.file_text));
        break;
      case 3:
        title = "Record Expenditure";
        list.add(TransactionMenu("EXPENSES", LineAwesomeIcons.file_text));
        list.add(TransactionMenu(
            "BANK LOAN REPAYMENTS", LineAwesomeIcons.file_text));
        list.add(
            TransactionMenu("CONTRIBUTION REFUND", LineAwesomeIcons.file_text));
        break;
      case 4:
        title = "Invoicing and Transfer";
        list.add(TransactionMenu("CREATE INVOICE", LineAwesomeIcons.file_text));
        list.add(TransactionMenu("FINE MEMBER", LineAwesomeIcons.file_text));
        list.add(TransactionMenu(
            "CONTRIBUTION TRANSFER", LineAwesomeIcons.file_text));
        list.add(TransactionMenu(
            "ACCOUNT TO ACCOUNT TRANSFER", LineAwesomeIcons.file_text));
        break;
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
                return gridButton(
                    context: context,
                    icon: list[index].icon,
                    title: list[index].title,
                    color: (index == 0) ? Colors.white : Colors.blueGrey[400],
                    isHighlighted: (index == 0) ? true : false,
                    action: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return navigate(originFlag, index);
                        })));
              }),
            );
          },
        ),
      ),
    );
  }

  Widget navigate(int origin, int index) {
    Widget target = WithdrawalPurpose();
    switch (origin) {
      case 0:
        target =
            (index == 0) ? WithdrawalPurpose() : ReviewWithdrawalRequests();
        break;
      case 1:
        target = (index == 0) ? ReviewLoanApplications() : RecordLoanPayment();
        break;
      case 2:
        if (index == 0) {
          target = RecordContributionPayment();
        } else if (index == 1) {
          target = RecordFinePayment();
        }

        break;
      case 3:
        if (index == 0) {
          target = RecordExpense();
        } else if (index == 1) {
          target = BankLoanRepayment();
        } else if (index == 2) {
          target = RecordContributionRefund();
        }

        break;
    }

    return target;
  }
}
