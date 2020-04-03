import 'package:chamasoft/screens/chamasoft/transactions/expense-categories-list.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class WithdrawalPurpose extends StatefulWidget {
  @override
  _WithdrawalPurposeState createState() => _WithdrawalPurposeState();
}

class _WithdrawalPurposeState extends State<WithdrawalPurpose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                screenActionButton(
                  icon: LineAwesomeIcons.arrow_left,
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  textColor: Colors.blue,
                  action: () => Navigator.of(context).pop(),
                ),
                SizedBox(width: 20.0),
                heading2(color: Colors.blue, text: "Purpose of Withdrawal"),
              ],
            ),
          ],
        ),
        elevation: 1,
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: primaryGradient(context),
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(4, (index) {
            String title = "Expense Payment";
            IconData icon = Feather.shopping_cart;
            if (index == 1) {
              title = "Contribution Refund";
              icon = Feather.git_pull_request;
            } else if (index == 2) {
              title = "Loan Disbursement";
              icon = Feather.credit_card;
            } else if (index == 3) {
              title = "Miscellanous Payment";
            }

            return GridItem(
              title: title,
              icon: icon,
              onTapped: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ExpenseCategoriesList())),
            );
          }),
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  const GridItem({Key key, @required this.title, this.icon, this.onTapped})
      : super(key: key);

  final String title;
  final IconData icon;
  final Function onTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(4.0),
      height: 150,
      decoration: cardDecoration(
          gradient: plainCardGradient(context), context: context),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          onTap: onTapped,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 35.0,
                color: Colors.blue,
              ),
              SizedBox(
                height: 15.0,
              ),
              subtitle2(
                  text: title, color: Colors.blue, align: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}