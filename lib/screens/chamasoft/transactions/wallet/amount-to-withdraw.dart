import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class AmountToWithdraw extends StatefulWidget {
  final Map<String, String> formData;

  AmountToWithdraw({this.formData});

  @override
  _AmountToWithdrawState createState() => _AmountToWithdrawState();
}

class _AmountToWithdrawState extends State<AmountToWithdraw> {
  TextEditingController _controller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String requestId =
      ((DateTime.now().toUtc().millisecondsSinceEpoch.toDouble() / 1000)
          .toStringAsFixed(0));
  bool _isLoading = false;
  bool _isFormInputEnabled = true;

  void _submitRequest(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    widget.formData['amount'] = _controller.text;
    widget.formData['request_id'] = requestId;

    setState(() {
      _isLoading = true;
      _isFormInputEnabled = false;
    });

    try {
      final requestId = await Provider.of<Groups>(context, listen: false)
          .createWithdrawalRequest(widget.formData);

      alertDialogWithAction(context, "Withdrawal request has been submitted",
          () {
        Navigator.of(context).pop();
        if (requestId == "-1") {
          //request is duplicate
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 3);
        } else
          Navigator.of(context).pop(requestId);
      }, false);
      setState(() {
        _isLoading = false;
        _isFormInputEnabled = true;
      });
    } on CustomException catch (error) {
      setState(() {
        _isLoading = false;
        _isFormInputEnabled = true;
      });
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _submitRequest(context);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    int withdrawalFor = int.tryParse(widget.formData['withdrawal_for']) ?? 0;
    int recipient = int.tryParse(widget.formData['recipient']) ?? 0;
    String title = "Expense Payment";
    String namePlaceholder = "Expense";
    String typePlaceholder = "Contribution";
    if (withdrawalFor == 2) {
      title = "Contribution Refund";
      namePlaceholder = "Contribution";
      typePlaceholder = "Member";
    } else if (withdrawalFor == 3) {
      title = "Merry Go Round";
      namePlaceholder = "Member";
    } else if (withdrawalFor == 4) {
      title = "Loan Disbursement";
      namePlaceholder = "Loan Type";
      typePlaceholder = "Member";
    }

    return Scaffold(
        appBar: secondaryPageAppbar(
          context: context,
          action: () => Navigator.of(context).pop(),
          elevation: 1,
          leadingIcon: LineAwesomeIcons.close,
          title: "Set Amount To Withdraw",
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Builder(builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      width: double.infinity,
                      color: (themeChangeProvider.darkTheme)
                          ? Colors.blueGrey[800]
                          : Color(0xffededfe),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          heading2(
                            text: title,
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              subtitle1(
                                text: "$namePlaceholder: ",
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                              ),
                              Expanded(
                                flex: 1,
                                child: customTitle(
                                  text: widget.formData['name'],
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: withdrawalFor == 2 || withdrawalFor == 4,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                subtitle1(
                                  text: "$typePlaceholder: ",
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: customTitle(
                                    text: widget.formData['member_name'] != null
                                        ? widget.formData['member_name']
                                        : '',
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionHandleColor,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: recipient == 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                subtitle1(
                                  text: "Bank: ",
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                ),
                                Expanded(
                                    child: customTitle(
                                  textAlign: TextAlign.start,
                                  text: widget.formData['bank_name'] != null
                                      ? widget.formData['bank_name']
                                      : '',
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                  fontWeight: FontWeight.w600,
                                )),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              subtitle1(
                                text: recipient == 1
                                    ? "Recipient Contact: "
                                    : "Recipient Account: ",
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                              ),
                              Expanded(
                                  child: customTitleWithWrap(
                                textAlign: TextAlign.start,
                                text: recipient == 1
                                    ? widget.formData['phone']
                                    : widget.formData['account_number'],
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                                fontWeight: FontWeight.w600,
                              )),
                            ],
                          ),
                          Visibility(
                            visible: withdrawalFor == 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                subtitle1(
                                  text: "Description: ",
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                ),
                                Expanded(
                                  child: customTitle(
                                    textAlign: TextAlign.start,
                                    text: widget.formData['description'] != null
                                        ? widget.formData['description']
                                        : '',
                                    color: Theme.of(context)
                                        // ignore: deprecated_member_use
                                        .textSelectionHandleColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            amountTextInputField(
                                context: context,
                                enabled: _isFormInputEnabled,
                                controller: _controller,
                                labelText: 'Amount to withdraw',
                                validator: (value) {
                                  if (value == null || value == "") {
                                    return "This field is required";
                                  } else {
                                    int amount = int.tryParse(value) ?? 0;
                                    if (amount < 1) {
                                      return "Invalid amount";
                                    }
                                  }
                                  return null;
                                }),
                            SizedBox(
                              height: 24,
                            ),
                            _isLoading
                                ? Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  )
                                : defaultButton(
                                    context: context,
                                    text: "SUBMIT REQUEST",
                                    onPressed: () => _submitRequest(context),
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
