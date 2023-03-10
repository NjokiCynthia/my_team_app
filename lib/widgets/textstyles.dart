import 'package:chamasoft/helpers/common.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
//import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'buttons.dart';

Widget heading1(
    {String text, Color color, TextAlign textAlign = TextAlign.center}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 24.0,
      color: color,
    ),
    textAlign: textAlign,
  );
}

Widget heading2(
    {String text, Color color, TextAlign textAlign = TextAlign.center}) {
  return Text(
    text,
    style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 17.0,
        color: color,
        fontFamily: 'SegoeUI'),
    textAlign: textAlign,
  );
}

Widget heading3(
    {String text, Color color, TextAlign textAlign = TextAlign.center}) {
  return Text(
    text,
    style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16.0,
        color: color,
        fontFamily: 'SegoeUI'),
    textAlign: textAlign,
  );
}

Widget subtitle1(
    {String text, Color color, TextAlign textAlign = TextAlign.center}) {
  return Text(
    text,
    style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16.0,
        color: color,
        fontFamily: 'SegoeUI'),
    textAlign: textAlign,
  );
}

Widget subtitle2(
    {String text,
    Color color,
    TextAlign textAlign = TextAlign.center,
    double fontSize}) {
  return Text(
    text,
    style: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: fontSize ?? 13.0,
        color: color,
        fontFamily: 'SegoeUI'),
    textAlign: textAlign,
  );
}

Widget subtitle3(
    {String text, Color color, TextAlign textAlign = TextAlign.center}) {
  return Text(
    text,
    style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 13.0,
        color: color,
        fontFamily: 'SegoeUI'),
    textAlign: textAlign,
  );
}

Widget customTitle1(
    {String text,
    Color color,
    TextAlign textAlign = TextAlign.center,
    double fontSize = 20.0,
    FontWeight fontWeight = FontWeight.w400,
    String fontFamily = 'SegoeUI'}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontFamily,
      color: color,
    ),
    textAlign: textAlign,
    overflow: TextOverflow.ellipsis,
  );
}

Widget customTitle(
    {String text,
    Color color,
    TextAlign textAlign = TextAlign.center,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w400,
    String fontFamily = 'SegoeUI'}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontFamily,
      color: color,
    ),
    textAlign: textAlign,
    overflow: TextOverflow.ellipsis,
  );
}

Widget customTitle2(
    {String text,
    Color color,
    TextAlign textAlign = TextAlign.center,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w400,
    String fontFamily = 'SegoeUI'}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontFamily,
      color: color,
    ),
    textAlign: textAlign,
    overflow: TextOverflow.clip,
  );
}

Widget customTitleWithWrap(
    {String text,
    Color color,
    TextAlign textAlign = TextAlign.center,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w400,
    int maxLines = 2,
    String fontFamily = 'SegoeUI',
    Text child}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontFamily,
      color: color,
    ),
    textAlign: textAlign,
    maxLines: maxLines,
  );
}

Widget richTextWithWrap(
    {String title,
    String message,
    Color color,
    TextAlign textAlign = TextAlign.center,
    double fontSize = 16.0,
    int maxLines = 2,
    String fontFamily = 'SegoeUI'}) {
  return RichText(
      textAlign: textAlign,
      maxLines: maxLines,
      text: TextSpan(children: <TextSpan>[
        TextSpan(
            text: title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
              fontFamily: fontFamily,
              color: color,
            )),
        TextSpan(
            text: message,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: fontSize,
              fontFamily: fontFamily,
              color: color,
            ))
      ]));
}

Widget textWithExternalLinks(
    {Map<String, Map<String, dynamic>> textData, Color color, double size}) {
  if (textData.isNotEmpty) {
    List<TextSpan> _children = [];
    textData.forEach((text, options) {
      _children.add(
        options.isNotEmpty
            ? TextSpan(
                text: text.trim() + ' ',
                recognizer: TapGestureRecognizer()..onTap = options['url'],
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: options['color'],
                    fontFamily: 'SegoeUI',
                    fontWeight: options['weight']))
            : TextSpan(
                text: text.trim() + ' ',
              ),
      );
    });
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: size,
          color: color,
        ),
        children: _children,
      ),
    );
  } else {
    return subtitle2(text: "", color: Colors.blueGrey);
  }
}

List<Widget> contributionSummary(
    {Color color,
    IconData cardIcon,
    String currency,
    String cardAmount,
    String amountDue,
    String dueDate,
    String contributionName}) {
  List<Widget> _data = [];
  List<String> _name = contributionName.split(" ");
  _data.clear();
  if (_name.length == 1) {
    _data.add(Stack(
      children: <Widget>[
        Icon(
          cardIcon,
          color: color.withOpacity(0.6),
          size: 38.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  width: 90.0,
                  child: customTitle(
                    text: contributionName,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.end,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ));
  }
  if (_name.length == 2) {
    _data.add(Stack(
      children: <Widget>[
        Icon(
          cardIcon,
          color: color.withOpacity(0.6),
          size: 38.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 0.0,
                ),
                Container(
                  width: 90.0,
                  child: Text(
                    _name[0],
                    style: TextStyle(
                      color: color,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 90.0,
                  child: Text(
                    _name[1],
                    style: TextStyle(
                      color: color,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ));
  }
  if (_name.length > 2) {
    _data.add(Stack(
      children: <Widget>[
        Icon(
          cardIcon,
          color: color.withOpacity(0.6),
          size: 38.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 6.0,
                ),
                Container(
                  width: 90.0,
                  child: Text(
                    contributionName,
                    style: TextStyle(
                      color: color,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ));
  }
  _data.add(SizedBox(
    height: 14.0,
  ));
  _data.add(
    Row(
      children: <Widget>[
        Text(
          "$currency ",
          style: TextStyle(
            color: color.withOpacity(0.6),
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          cardAmount,
          style: TextStyle(
            color: color,
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
  _data.add(SizedBox(
    height: 10.0,
  ));
  if (amountDue != "") {
    _data.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Amount Due",
              style: TextStyle(
                color: color.withOpacity(0.6),
                fontSize: 11.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: <Widget>[
                if (currency != null)
                  Text(
                    "$currency ",
                    style: TextStyle(
                      color: color,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                if (amountDue != null)
                  Text(
                    amountDue,
                    style: TextStyle(
                      color: color,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                  )
              ],
            ),
            if (dueDate != null)
              Text(
                dueDate,
                style: TextStyle(
                  color: color.withOpacity(0.6),
                  fontSize: 10.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ],
    ));
  }
  return _data;
}

List<Widget> resetTransactions(
    {Color color,
    IconData cardIcon,
    String currency = "KES",
    String cardAmount,
    String paymentDate,
    String paymentMethod,
    String contributionType,
    String paymentDescription}) {
  List<Widget> _data = [];
  _data.clear();
  List<String> _name = paymentDescription.split(" ");
  if (_name.length == 1) {
    _data.add(Stack(
      children: <Widget>[
        Icon(
          cardIcon,
          color: color.withOpacity(0.6),
          size: 30.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  width: 90.0,
                  child: customTitle(
                    text: paymentDescription,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.end,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ));
  }
  if (_name.length == 2) {
    _data.add(Stack(
      children: <Widget>[
        Icon(
          cardIcon,
          color: color.withOpacity(0.6),
          size: 30.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 0.0,
                ),
                Container(
                  width: 90.0,
                  child: Text(
                    _name[0],
                    style: TextStyle(
                      color: color,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 90.0,
                  child: Text(
                    _name[1],
                    style: TextStyle(
                      color: color,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ));
  }
  if (_name.length > 2) {
    _data.add(Stack(
      children: <Widget>[
        Icon(
          cardIcon,
          color: color.withOpacity(0.6),
          size: 30.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 6.0,
                ),
                Container(
                  width: 90.0,
                  child: Text(
                    paymentDescription,
                    style: TextStyle(
                      color: color,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ));
  }
  _data.add(SizedBox(
    height: 15.0,
  ));
  _data.add(
    Row(
      children: <Widget>[
        Text(
          "$currency ",
          style: TextStyle(
            color: color.withOpacity(0.6),
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          cardAmount,
          style: TextStyle(
            color: color,
            fontSize: 18.0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
  _data.add(SizedBox(
    height: 10.0,
  ));
  _data.add(Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      Text(
        paymentMethod ?? "Cash Payment",
        style: TextStyle(
          color: color.withOpacity(0.6),
          fontSize: 10.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      Text(
        paymentDate,
        style: TextStyle(
          color: color.withOpacity(0.8),
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 10.0,
              color: color.withOpacity(0.6),
            ),
            children: [
              TextSpan(text: contributionType ?? ""),
            ]),
      )
    ],
  ));
  return _data;
}

Widget transactionToolTip(
    {BuildContext context,
    @required String title,
    @required String date,
    @required String message,
    bool visible = true,
    Function toggleToolTip}) {
  return Visibility(
    visible: visible,
    child: Container(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        color: (themeChangeProvider.darkTheme)
            ? Colors.blueGrey[800]
            : Color(0xffededfe),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.lightbulb_outline,
              // ignore: deprecated_member_use
              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  subtitle1(
                    text: title,
                    textAlign: TextAlign.start,
                    // ignore: deprecated_member_use
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor,
                    //Theme.of(context).textSelectionHandleColor
                  ),
                  (date.length > 0)
                      ? subtitle2(
                          text: date,
                          textAlign: TextAlign.start,
                          // ignore: deprecated_member_use
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor,
                        )
                      : Container(),
                  (message.length > 0)
                      ? subtitle2(
                          text: message,
                          // ignore: deprecated_member_use
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor,
                          textAlign: TextAlign.start)
                      : Container(),
                ],
              ),
            ),
            Visibility(
              visible: false,
              child: screenActionButton(
                  icon: LineAwesomeIcons.clone,
                  // ignore: deprecated_member_use
                  textColor:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
                  action: toggleToolTip),
            ),
          ],
        )),
  );
}

Widget toolTip(
    {BuildContext context,
    @required String title,
    @required String message,
    bool showTitle = true,
    bool visible = true,
    Function toggleToolTip}) {
  return Visibility(
    visible: visible,
    child: Container(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        color: (themeChangeProvider.darkTheme)
            ? Colors.blueGrey[800]
            : Color(0xffededfe),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.lightbulb_outline,
              // ignore: deprecated_member_use
              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  (showTitle)
                      ? subtitle1(
                          text: title,
                          textAlign: TextAlign.start,
                          // ignore: deprecated_member_use
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor,
                        )
                      : Container(),
                  (message.length > 0)
                      ? subtitle2(
                          text: message,
                          // ignore: deprecated_member_use
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor,
                          textAlign: TextAlign.start)
                      : Container(),
                ],
              ),
            ),
            Visibility(
              visible: false,
              child: screenActionButton(
                  icon: LineAwesomeIcons.clone,
                  // ignore: deprecated_member_use
                  textColor:
                      Theme.of(context).textSelectionTheme.selectionHandleColor,
                  action: toggleToolTip),
            ),
          ],
        )),
  );
}

Widget accountBalance(
    {Color color,
    IconData cardIcon,
    String currency,
    String cardAmount,
    String accountName}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      Icon(
        cardIcon,
        color: color.withOpacity(0.6),
        size: 38.0,
      ),
      SizedBox(
        height: 5,
      ),
      RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        text: TextSpan(
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
                color: color,
                fontFamily: 'SegoeUI'),
            children: [
              TextSpan(text: accountName.toUpperCase()),
              TextSpan(text: " "),
              TextSpan(
                  text: "BALANCE",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: color,
                      fontFamily: 'SegoeUI'))
            ]),
      ),
      SizedBox(
        height: 5,
      ),
      Center(
        child: FittedBox(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20.0,
                    color: color,
                    fontFamily: 'SegoeUI'),
                children: [
                  TextSpan(
                      text: currency,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0,
                          color: color,
                          fontFamily: 'SegoeUI')),
                  TextSpan(text: " "),
                  TextSpan(text: cardAmount),
                ]),
          ),
        ),
      ),
    ],
  );
}
