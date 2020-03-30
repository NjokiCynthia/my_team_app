import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

Widget defaultButton({ BuildContext context, String text, Function onPressed}) {
  return RaisedButton(
    color: Colors.blue,
    child: Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Text(text),
    ),
    textColor: Colors.white,
    onPressed: onPressed,
  );
}

Widget screenActionButton({IconData icon, Color backgroundColor, Color textColor, Function action, double buttonSize = 42.0, double iconSize = 22.0}) {
  return Container(
    width: buttonSize,
    height: buttonSize,
    child: FlatButton(
      padding: EdgeInsets.all(0.0),
      child: Icon(
        icon,
        size: iconSize,
      ),
      onPressed: action,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      textColor: textColor,
      color: backgroundColor,
    ),
  );
}

Widget groupInfoButton({BuildContext context, IconData leadingIcon, IconData trailingIcon, bool hideTrailingIcon = false, Color backgroundColor, Color textColor, String title, String subtitle, String description = "", Color borderColor, Function action}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    // height: 42.0,
    child: OutlineButton(
        padding: EdgeInsets.all(0.0),
        child: ListTile(
          dense: true,
          enabled: true,
          leading: Icon(
            leadingIcon,
            color: textColor.withOpacity(0.8),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10,),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: <Widget>[
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontWeight: FontWeight.w800,
                      fontSize: 12.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  (description != "") ? Text(
                    ", " + description,
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ) : SizedBox(),
                ],
              ),
              SizedBox(height: 10,),
            ],
          ),
          trailing: hideTrailingIcon ? SizedBox() : Icon(
            trailingIcon,
            color: textColor.withOpacity(0.8),
            size: 16.0,
          ),
        ),
        onPressed: action,
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
        borderSide: BorderSide(
          color: borderColor, 
          style: BorderStyle.solid, 
          width: 2
        ),
        textColor: textColor,
        color: backgroundColor,
        highlightedBorderColor: borderColor,
      ),
  );
}

Widget smallBadgeButton({Color backgroundColor, String text, Color textColor, Function action, double buttonHeight = 24.0, double textSize = 12.0}) {
  return Container(
    height: buttonHeight,
    child: FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w400,
          fontSize: textSize,
        ),
      ),
      onPressed: action,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      textColor: textColor,
      color: backgroundColor,
    ),
  );
}

Widget groupSwitcherButton({BuildContext context, String title, String role}) {
  return FlatButton(
    padding: EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
    child: Column(
      children: <Widget>[
        Container(
          // height: 32.0,
          constraints: BoxConstraints(maxWidth: 320),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.blueGrey[400],
                        fontWeight: FontWeight.w900,
                        fontSize: 16.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          size: 12.0,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          role,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w900,
                            fontSize: 14.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: 32.0,
                width: 32.0,
                margin: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Theme.of(context).hintColor.withOpacity(0.4),
                ),
                child: Icon(
                  Feather.users,
                  color: Colors.white70,
                  size: 18.0,
                ),
                // ** If group image is available, replace above child with this: **
                // =================================================================
                // child: Image(
                //   image:  AssetImage('assets/no-user.png'),
                //   height: 32.0,
                // ),
              ),
            ]
          ),
        ),
      ],
    ),
    onPressed: (){},
    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
    textColor: Colors.blue,
    color: Theme.of(context).buttonColor,
  );
}

Widget cardAmountButton({String currency, String amount, Function action, double size, Color color}) {
  return FlatButton(
    padding: EdgeInsets.fromLTRB(16.0, 0.0, 6.0, 0.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          "$currency ",
          style: TextStyle(
            color: color,
            fontSize: (size - 2.0),
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: size,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.end,
        ),
        SizedBox(width: 10.0,),
        Icon(
          Feather.chevron_right,
          size: (size - 4.0),
          color: color.withOpacity(0.4),
        )
      ],
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    onPressed: action,
    highlightColor: Colors.blueGrey.withOpacity(0.1),
  );
}

Widget paymentActionButton({bool isFlat = false, String text, IconData icon, double iconSize = 12.0, Color color, Function action, Color textColor}) {
  return (!isFlat) ? OutlineButton(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
          ),
        ),
        SizedBox(width: 10.0,),
        Icon(
          icon,
          color: textColor,
          size: iconSize,
        ),
      ],
    ),
    borderSide: BorderSide(
      width: 3.0,
      color: color,
    ),
    highlightColor: color.withOpacity(0.1),
    highlightedBorderColor: color,
    onPressed: action,
  ) : FlatButton(
    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
          ),
        ),
        SizedBox(width: 10.0,),
        Icon(
          icon,
          color: textColor,
          size: iconSize,
        ),
      ],
    ),
    color: color,
    onPressed: action,
  );
}
