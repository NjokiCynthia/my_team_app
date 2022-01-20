import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/contribution-statement.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:chamasoft/providers/groups.dart' as GroupsProvider;
import 'package:provider/provider.dart';

class NotificationAlert extends StatefulWidget {
  final GroupsProvider.Notification notification;

  const NotificationAlert({this.notification});

  @override
  _NotificationAlertState createState() => _NotificationAlertState();
}

class _NotificationAlertState extends State<NotificationAlert> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // ignore: todo
    // TODO: implement didChangeDependencies
    //mark notification as read
    if (widget.notification.isRead == '0') {
      Provider.of<Groups>(context, listen: false)
          .markNotificationAsRead((widget.notification.id).toString());
    }

    super.didChangeDependencies();
  }

  // void _takeNotificationAction() {
  //   return null;
  // }

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
                    text: widget.notification.subject != null
                        ? widget.notification.subject
                        : "Null subject",
                    color: primaryColor.withOpacity(0.8),
                    textAlign: TextAlign.center,
                  ),
                  subtitle1(
                    text: " ",
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
                    fadeOutDuration: const Duration(milliseconds: 700),
                    fadeInDuration: const Duration(milliseconds: 1000),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  subtitle2(
                    text: widget.notification.message != null
                        ? widget.notification.message
                        : "The message is null",
                    color: primaryColor.withOpacity(0.8),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // ignore: deprecated_member_use
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: customTitle(
                          text: "Cancel",
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.2),
                            padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(4.0))),
                      ),
                      TextButton(
                        onPressed: () => {
                          //  _eventDispatcher.add('TAP'), //Closes the AppSwitcher
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ContributionStatement(),
                            ),
                          ),
                        },
                        child: customTitle(
                          text: "View Statement",
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        style: TextButton.styleFrom(
                            primary: primaryColor,
                            backgroundColor: primaryColor.withOpacity(0.2),
                            padding: EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 0.0),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(4.0))),
                      ),
                    ],
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
