import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/amount-to-withdraw.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ListBanks extends StatefulWidget {
  static const namedRoute = 'list-banks';

  final Map<String, String> formData;

  ListBanks({this.formData});

  @override
  _ListBanksState createState() => _ListBanksState();
}

class _ListBanksState extends State<ListBanks> {
  List<Bank> _banksList = [];
  String filter;
  TextEditingController _controller = new TextEditingController();
  TextEditingController _accountController = new TextEditingController();

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        filter = _controller.text;
      });
    });
    super.initState();
  }

  void _numberPrompt(Bank bank) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: heading2(
              text: "Set Bank Account", color: Theme.of(context).textSelectionHandleColor, textAlign: TextAlign.start),
          content: TextFormField(
            controller: _accountController,
            style: inputTextStyle(),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 1.0,
              )),
              // hintText: 'Phone Number or Email Address',
              labelText: "Enter Account Number",
            ),
          ),
          actions: <Widget>[
            negativeActionDialogButton(
                text: "Cancel",
                color: Theme.of(context).textSelectionHandleColor,
                action: () {
                  Navigator.of(context).pop();
                }),
            positiveActionDialogButton(
                text: "Continue",
                color: primaryColor,
                action: () async {
                  if (_accountController.text.length > 5) {
                    widget.formData["account_number"] = _accountController.text;
                    widget.formData["bank_id"] = bank.id.toString();
                    widget.formData["bank_name"] = bank.name;

                    Navigator.of(context).pop();
                   final result = await Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AmountToWithdraw(formData: widget.formData)));
                   if(result != null){
                     final id = int.tryParse(result) ?? 0;
                     if(id != 0){
                       Navigator.of(context).pop(result);
                     }
                   }
                  }
                })
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = "Select Bank";
    String labelText = "Search Bank";
    _banksList = Provider.of<Groups>(context).bankOptions;

    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        leadingIcon: LineAwesomeIcons.close,
        title: title,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(top: 16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: labelText,
                    prefixIcon: Icon(LineAwesomeIcons.search),
                  ),
                  controller: _controller,
                ),
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (_, int index) {
                        String name = _banksList[index].name;
                        int id = _banksList[index].id;
                        return filter == null || filter.isEmpty
                            ? buildListTile(_banksList[index])
                            : name.toLowerCase().contains(filter.toLowerCase())
                                ? buildListTile(_banksList[index])
                                : Visibility(visible: false, child: new Container());
                      },
                      itemCount: _banksList.length),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  ListTile buildListTile(Bank bank) {
    return ListTile(
      title: customTitle(text: bank.name, textAlign: TextAlign.start),
      onTap: () => _numberPrompt(bank),
    );
  }
}
