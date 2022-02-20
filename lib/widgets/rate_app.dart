import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateAppInitWidget extends StatefulWidget {
  final Widget Function(RateMyApp) builder;

  const RateAppInitWidget({
    Key key,
    @required this.builder,
  }) : super(key: key);

  @override
  _RateAppInitWidgetState createState() => _RateAppInitWidgetState();
}

class _RateAppInitWidgetState extends State<RateAppInitWidget> {
  RateMyApp rateMyApp;

  static const playStoreId = 'chamasoft.app';
  // static const appstoreId = 'com.apple.mobilesafari';

  @override
  Widget build(BuildContext context) => RateMyAppBuilder(
        rateMyApp: RateMyApp(
          googlePlayIdentifier: playStoreId,
          minDays: 1,
          minLaunches: 2,
          preferencesPrefix: 'rateMyApp_',
          remindDays: 3,
          remindLaunches: 1,
        ),
        onInitialized: (context, rateMyApp) {
          setState(() => this.rateMyApp = rateMyApp);

          if (rateMyApp.shouldOpenDialog) {
            rateMyApp.showStarRateDialog(
              context,
              title: 'Enjoying Chamasoft?',
              message: 'Please Rate Chamasoft mobile App.',
              // starRatingOptions:StarRatingOptions(initialRating: 4),

              dialogStyle: DialogStyle(
                  titleAlign: TextAlign.center,
                  messageAlign: TextAlign.start,
                  messagePadding: EdgeInsets.only(bottom: 20)),
              // ignoreNativeDialog: Platform.isIOS,
              actionsBuilder: (context, stars) {
                return [
                  // ignore: deprecated_member_use
                  defaultButton(
                    context: context,
                    text: 'Rate',
                    onPressed: () {
                      if (stars != null) {
                        //   rateMyApp.d
                        //  rateMyApp.doNotOpenAgain = true;
                        rateMyApp.save().then((v) => Navigator.pop(context));

                        if (stars <= 2.5) {
                          Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: primaryColor,
                              textColor: Colors.white,
                              fontSize: 16.0,
                              msg:
                                  "Good news: Ratings successfuly recorded. Thankyou");
                        } else if (stars <= 5) {
                          print('Open Google Playstore');
                          rateMyApp.launchStore();
                        }
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ];
              },
              starRatingOptions: StarRatingOptions(
                  itemColor: Theme.of(context).primaryColor, initialRating: 4),
            );
          }
        },
        builder: (context) => rateMyApp == null
            ? Center(child: CircularProgressIndicator())
            : widget.builder(rateMyApp),
      );
}
