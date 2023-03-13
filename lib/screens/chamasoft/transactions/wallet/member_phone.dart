import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/amount-to-withdraw.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/contact_list.dart';
import 'package:chamasoft/screens/chamasoft/transactions/wallet/phone_number.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class NumberKeyBoard extends StatefulWidget {
  final Map<String, String> formData;
  final String phoneNumber;
  const NumberKeyBoard({Key key, this.formData, this.phoneNumber})
      : super(key: key);

  @override
  State<NumberKeyBoard> createState() => _NumberKeyBoardState();
}

class _NumberKeyBoardState extends State<NumberKeyBoard> {
  final TextEditingController _myController = TextEditingController();

  //  widget.formData['phone'] = _myController;

  @override
  Widget build(BuildContext context) {
    print(" Phone Number is : ${widget.phoneNumber}");
    // _myController.text = widget.phoneNumber;
    return Scaffold(
      appBar: tertiaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: 2.5,
        leadingIcon: LineAwesomeIcons.times,
        title: "Phone Number",
        /*  trailingIcon: LineAwesomeIcons.user_plus,
          trailingAction: () => _numberPrompt() */
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // display the entered numbers
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 70,
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: Center(
                    child: TextField(
                  controller: _myController,
                  textAlign: TextAlign.center,
                  showCursor: false,
                  style: inputTextStyle(),
                  // Disable the default soft keybaord
                  keyboardType: TextInputType.none,
                  inputFormatters: <TextInputFormatter>[
                    // ignore: deprecated_member_use
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                      width: 1.0,
                    )),
                    // hintText: 'Phone Number or Email Address',
                    labelText: "Enter Phone Number",
                  ),
                )),
              ),
            ),

            SizedBox(height: 30),

            Visibility(
              visible: false,
              child: Container(
                padding: EdgeInsets.only(left: 50, right: 50),
                height: 45.0,
                child: paymentActionButton(
                    color: primaryColor,
                    textColor: Colors.white,
                    icon: FontAwesome.bank,
                    isFlat: true,
                    text: "Select from Contact",
                    iconSize: 12.0,
                    action: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ContactList(formData: widget.formData

                                  // member: member,
                                  ))); // pop bottom sheet
                      // if (result != null && result) {
                      //   _refreshIndicatorKey.currentState.show();
                      //   _fetchMembers(context);
                      // }
                    },
                    showIcon: false),
              ),
            ),

            SizedBox(height: 30),
            // implement the custom NumPad
            NumPad(
              buttonSize: 55,
              buttonColor: primaryColor,
              iconColor: Colors.red,
              iconCollorSubmit: Colors.green,
              controller: _myController,
              delete: () {
                _myController.text = _myController.text
                    .substring(0, _myController.text.length - 1);
              },
              // do something with the input numbers
              onSubmit: () {
                print("Phone: ${_myController.text}");
                if (CustomHelper.validPhone(_myController.text)) {
                  // Navigator.of(context).pop();
                  // _proceedToAmountPage(2);

                  widget.formData['phone'] = _myController.text;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AmountToWithdraw(formData: widget.formData)));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
