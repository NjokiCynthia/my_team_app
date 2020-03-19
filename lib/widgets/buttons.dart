import 'package:flutter/material.dart';

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

Widget screenActionButton({IconData icon, Color backgroundColor, Color textColor, Function action}) {
  return Container(
    width: 42.0,
    height: 42.0,
    child: FlatButton(
      padding: EdgeInsets.all(0.0),
      child: Icon(
        icon,
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
