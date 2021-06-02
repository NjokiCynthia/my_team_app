import 'package:chamasoft/providers/groups.dart' as Groups;
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class NotificationDetails extends StatefulWidget {
  final Groups.Notification notification;
  NotificationDetails({this.notification}) {
    print(this.notification.subject);
  }
  @override
  _NotificationDetailsState createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  void _numberToPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: heading2(
              text: "Confirm Mpesa Number",
              // ignore: deprecated_member_use
              color: Theme.of(context).textSelectionHandleColor,
              textAlign: TextAlign.start),
          content: TextFormField(
            //controller: controller,
            style: inputTextStyle(),
            initialValue: "254712233344",
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              // ignore: deprecated_member_use
              WhitelistingTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 1.0,
              )),
              // hintText: 'Phone Number or Email Address',
              labelText: "Mpesa Number",
            ),
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                    // ignore: deprecated_member_use
                    color: Theme.of(context).textSelectionHandleColor,
                    fontFamily: 'SegoeUI'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // ignore: deprecated_member_use
            new FlatButton(
              child: new Text(
                "Pay Now",
                style:
                    new TextStyle(color: primaryColor, fontFamily: 'SegoeUI'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
          title: widget.notification.subject,
          action: () => Navigator.pop(context,true),
          elevation: 2.5,
          leadingIcon: LineAwesomeIcons.close),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            color: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[800]
                : Color(0xffededfe),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: heading2(
                        text: widget.notification.message,
                        // ignore: deprecated_member_use
                        color: Theme.of(context).textSelectionHandleColor,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        customTitle(
                          text: "Ksh ",
                          fontSize: 18.0,
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                          fontWeight: FontWeight.w400,
                        ),
                        heading2(
                          text: "2,000",
                          // ignore: deprecated_member_use
                          color: Theme.of(context).textSelectionHandleColor,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    subtitle1(
                      text: "Group: ",
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionHandleColor,
                    ),
                    customTitle(
                      textAlign: TextAlign.start,
                      text: "Freedom Welfare Caucus",
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionHandleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    subtitle1(
                      text: "Invoice Date: ",
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionHandleColor,
                    ),
                    customTitle(
                      textAlign: TextAlign.start,
                      text: "12 May 2020",
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionHandleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    subtitle1(
                      text: "Due Date: ",
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionHandleColor,
                    ),
                    customTitle(
                      textAlign: TextAlign.start,
                      text: "20 May 2020",
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionHandleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child: textWithExternalLinks(
                color: Colors.blueGrey,
                size: 12.0,
                textData: {
                  'Additional charges may be applied where necessary.': {},
                  'Learn More': {
                    "url": () => launchURL(
                        'https://chamasoft.com/terms-and-conditions/'),
                    "color": primaryColor,
                    "weight": FontWeight.w500
                  },
                }),
          ),
          SizedBox(
            height: 24,
          ),
          defaultButton(
              context: context,
              text: "Pay Now",
              onPressed: () => _numberToPrompt())
        ],
      ),
    );
  }
}
