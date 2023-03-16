import 'package:chamasoft/screens/chamasoft/models/bank.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class BankList extends StatefulWidget {
  @override
  _BankListState createState() => _BankListState();
}

class _BankListState extends State<BankList> {
  final List<Bank> list = [
    Bank("1", "NCBA Bank", LineAwesomeIcons.piggy_bank),
    Bank("1", "KCB Bank", LineAwesomeIcons.piggy_bank),
    Bank("1", "Cooperative Bank", LineAwesomeIcons.piggy_bank),
    Bank("1", "ABSA Bank", LineAwesomeIcons.piggy_bank),
  ];

  void bankAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Acoount Number"),
          content: TextFormField(
            //controller: controller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 2.0,
              )),
              // hintText: 'Phone Number or Email Address',
              labelText: "Bank account number",
            ),
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            new TextButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                    // ignore: deprecated_member_use
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // ignore: deprecated_member_use
            new TextButton(
              child: new Text(
                "Proceed",
                style: new TextStyle(color: primaryColor),
              ),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: 1,
        leadingIcon: LineAwesomeIcons.times,
        title: "Select Your Bank",
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        //decoration: primaryGradient(context),
        color: Theme.of(context).backgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              margin: EdgeInsets.all(16.0),
              child: TextField(
                autocorrect: true,
                decoration: InputDecoration(
                  hintText: 'Search Bank',
                  hintStyle: TextStyle(color: Colors.blueGrey),
                  filled: false,
                  prefixIcon: Icon(
                    Feather.search,
                    size: 24,
                    color: Colors.blueGrey,
                  ),
                  fillColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Bank bank = list[index];
                  return Material(
                    color: Theme.of(context).backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0)),
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              LineAwesomeIcons.piggy_bank,
                              color: Colors.blueGrey,
                              size: 32,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            subtitle1(
                                text: bank.name,
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                textAlign: TextAlign.start),
                          ],
                        ),
                      ),
                      onTap: bankAccount,
                    ),
                  );
                },
                itemCount: list.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
