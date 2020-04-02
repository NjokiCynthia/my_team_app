import 'package:chamasoft/screens/chamasoft/transactions/bank-list.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/withdrawal-purpose.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class WithdrawalOption extends StatefulWidget {
  @override
  _WithdrawalOptionState createState() => _WithdrawalOptionState();
}

class _WithdrawalOptionState extends State<WithdrawalOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: 1,
          leadingIcon: LineAwesomeIcons.close,
          title: "Select Withdrawal Option",
        ),
        body: Container(
          //decoration: primaryGradient(context),
          color: Theme.of(context).backgroundColor,
          width: double.infinity,
          height: double.infinity,
          child: Container(
            height: 200,
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(2, (index) {
                String title = "Send to Phone";
                IconData icon = LineAwesomeIcons.mobile;
                if (index == 1) {
                  title = "Send to Bank";
                  icon = LineAwesomeIcons.bank;
                }

                return GridItem(
                  title: title,
                  icon: icon,
                  onTapped: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => BankList())),
                );
              }),
            ),
          ),
        ));
  }
}
