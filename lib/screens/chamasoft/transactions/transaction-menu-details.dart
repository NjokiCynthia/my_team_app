import 'package:chamasoft/screens/chamasoft/models/transaction-menu.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-bank-loan.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-contribution-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-fine-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-income.dart';
import 'package:chamasoft/screens/chamasoft/transactions/income/record-miscellaneous-payment.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/account-to-account-transfer.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/contribution-transfer.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/review-withdrawal-requests.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/withdrawal-purpose.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'expenditure/bank-loan-repayments.dart';
import 'expenditure/record-contribution-refund.dart';
import 'expenditure/record-expense.dart';
import 'invoicing-and-transfer/create-invoice.dart';
import 'invoicing-and-transfer/fine-member.dart';

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
            "REVIEW WITHDRAWAL REQUESTS", LineAwesomeIcons.file));
        break;
      case 1:
        title = "Loan Transactions";
        list.add(
            TransactionMenu("REVIEW LOAN APPLICATIONS", LineAwesomeIcons.file));
        list.add(
            TransactionMenu("RECORD LOAN REPAYMENTS", LineAwesomeIcons.file));
        break;
      case 1:
        title = "Record Payments";
        list.add(TransactionMenu("CONTRIBUTIONS", LineAwesomeIcons.file));
        list.add(TransactionMenu("FINES", LineAwesomeIcons.file));
        list.add(TransactionMenu("INCOME", LineAwesomeIcons.file));
        list.add(TransactionMenu("MISCELLANEOUS", LineAwesomeIcons.file));
        list.add(TransactionMenu("BANK LOANS", LineAwesomeIcons.file));
        break;
      case 2:
        title = "Record Expenditure";
        list.add(TransactionMenu("EXPENSES", LineAwesomeIcons.file));
        list.add(
            TransactionMenu("BANK LOAN REPAYMENTS", LineAwesomeIcons.file));
        list.add(TransactionMenu("CONTRIBUTION REFUND", LineAwesomeIcons.file));
        break;
      case 3:
        title = "Invoicing and Transfer";
        list.add(TransactionMenu("INVOICE MEMBERS", LineAwesomeIcons.file));
        list.add(TransactionMenu("FINE MEMBER", LineAwesomeIcons.file));
        list.add(
            TransactionMenu("CONTRIBUTION TRANSFER", LineAwesomeIcons.file));
        list.add(TransactionMenu(
            "ACCOUNT TO ACCOUNT TRANSFER", LineAwesomeIcons.file));
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
              padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
              crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
              children: List.generate(list.length, (index) {
                return gridButton(
                    context: context,
                    icon: list[index].icon,
                    title: list[index].title,
                    color: (index == 0) ? Colors.white : Colors.blue[400],
                    isHighlighted: (index == 0) ? true : false,
                    action: () => navigate(originFlag, index),
                    margin: 12);
              }),
            );
          },
        ),
      ),
    );
  }

  void navigate(int origin, int index) {
    switch (origin) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return (index == 0)
              ? WithdrawalPurpose()
              : ReviewWithdrawalRequests();
        }));
        break;
      // case 1:
      //   Navigator.of(context)
      //       .push(MaterialPageRoute(builder: (BuildContext context) {
      //     return (index == 0) ? ReviewLoanApplications() : RecordLoanPayment();
      //   }));
      //   break;
      case 1:
        if (index == 0) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return RecordContributionPayment();
          }));
        } else if (index == 1) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return RecordFinePayment();
          }));
        } else if (index == 2) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return RecordIncome();
          }));
        } else if (index == 3) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return RecordMiscellaneousPayment();
          }));
        } else if (index == 4) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return RecordBankLoan();
          }));
        }

        break;
      case 2:
        Widget target;
        if (index == 0) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return RecordExpense();
          }));
        } else if (index == 1) {
          target = BankLoanRepayment();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return target;
          }));
        } else if (index == 2) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return RecordContributionRefund();
          }));
        }
        break;

      case 3:
        if (index == 0) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return CreateInvoice();
          }));
        } else if (index == 1) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return FineMember();
          }));
        } else if (index == 2) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return ContributionTransfer();
          }));
        } else if (index == 3) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return AccountToAccountTransfer();
          }));
        }
        break;
    }
  }
}
