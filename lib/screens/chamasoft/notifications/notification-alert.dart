import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class NotificationAlert extends StatefulWidget {
  @override
  _NotificationAlertState createState() => _NotificationAlertState();
}

class _NotificationAlertState extends State<NotificationAlert> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SizedBox.expand(
        child: Container(
          padding: EdgeInsets.only(
            right: 20.0,
            bottom: 20.0,
            left: 20.0,
          ),
          color: Theme.of(context).backgroundColor.withOpacity(0.95),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  heading2(
                    text: "Some notification title",
                    color: primaryColor.withOpacity(0.8),
                    textAlign: TextAlign.center,
                  ),
                  subtitle1(
                    text: "Subtitle goes here",
                    color: primaryColor.withOpacity(0.8),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CachedNetworkImage(
                    imageUrl:
                        "https://chamasoft.com/wp-content/uploads/2020/02/ngo-concept-400x185.png",
                    placeholder: (context, url) => CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ),
                    imageBuilder: (context, image) => Image(
                      image: image,
                      width: double.infinity,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fadeOutDuration: const Duration(seconds: 1),
                    fadeInDuration: const Duration(seconds: 3),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  subtitle2(
                    text:
                        "Lorem ipsum dolor simet lorem ipsum dolor simet lorem ipsum dolor simet lorem ipsum dolor simet lorem ipsum dolor simet lorem ipsum dolor simet lorem ipsum.",
                    color: primaryColor.withOpacity(0.8),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
                    child: customTitle(
                      text: "Action Here",
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    onPressed: () {},
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(4.0)),
                    textColor: primaryColor,
                    color: primaryColor.withOpacity(0.2),
                  ),
                ],
              ),
              Positioned(
                top: 50.0,
                right: 0.0,
                child: screenActionButton(
                  icon: LineAwesomeIcons.remove,
                  backgroundColor: Colors.red.withOpacity(0.2),
                  textColor: Colors.red,
                  action: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
