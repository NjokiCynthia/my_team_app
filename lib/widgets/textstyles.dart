import 'package:chamasoft/utilities/common.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'buttons.dart';

Widget heading1(
    {String text, Color color, TextAlign align = TextAlign.center}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 24.0,
      color: color,
    ),
    textAlign: align,
  );
}

Widget heading2(
    {String text, Color color, TextAlign align = TextAlign.center}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 18.0,
      color: color,
    ),
    textAlign: align,
  );
}

Widget subtitle1(
    {String text, Color color, TextAlign align = TextAlign.center}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
      color: color,
    ),
    textAlign: align,
  );
}

Widget subtitle2(
    {String text, Color color, TextAlign align = TextAlign.center}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12.0,
      color: color,
    ),
    textAlign: align,
  );
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
                    color: options['color'], fontWeight: options['weight']))
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
                  child: Text(
                    contributionName,
                    style: TextStyle(
                      color: color,
                      fontSize: 22.0,
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
                      fontWeight: FontWeight.w800,
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
                      fontSize: 22.0,
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
                Text(
                  "$currency ",
                  style: TextStyle(
                    color: color,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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

Widget toolTip(
    {BuildContext context,
    @required String title,
    @required String message,
    bool visible = true,
    Function toggleToolTip}) {
  return Visibility(
    visible: visible,
    child: Container(
        padding: EdgeInsets.all(20.0),
        color: (themeChangeProvider.darkTheme)
            ? Colors.blueGrey[800]
            : Color(0xffededfe),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
//mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.lightbulb_outline,
              color: Theme.of(context).textSelectionHandleColor,
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
                      color: Theme.of(context).textSelectionHandleColor),
                  (message.length > 0)
                      ? subtitle2(
                          text: message,
                          color: Theme.of(context).textSelectionHandleColor,
                          align: TextAlign.start)
                      : Container(),
                ],
              ),
            ),
            screenActionButton(
                icon: LineAwesomeIcons.close,
//backgroundColor: Colors.blue.withOpacity(0.2),
                textColor: Theme.of(context).textSelectionHandleColor,
                action: toggleToolTip),
          ],
        )),
  );
}
