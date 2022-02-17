import 'dart:io';

import 'package:flutter/material.dart';
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
  //  =  RateMyApp(
  //   preferencesPrefix: 'rateMyApp_',
  //     googlePlayIdentifier: playStoreId,
  //         // appStoreIdentifier: appstoreId,
  //         minDays: 0,
  //         minLaunches: 1,
  //         // remindDays: 1,
  //         // remindLaunches: 1,
  //         remindDays: 7,
  //         remindLaunches: 10,

  // );

  // @override
  // void initState() {
  //   super.initState();
  //   _rateMyApp.init().then((_) {
  //     if(_rateMyApp.shouldOpenDialog){
  //       _rateMyApp.showStarRateDialog(context,
  //       title: 'Enjoying Chamasoft?',
  //       message: 'Please Rate Chamasoft mobile App.',
  //       dialogStyle: DialogStyle(
  //         titleAlign: TextAlign.center,
  //         messageAlign: TextAlign.start,
  //         messagePadding: EdgeInsets.only(bottom: 20)
  //       ), starRatingOptions: StarRatingOptions(),)
  //     }

  //   });
  // }

  static const playStoreId = 'chamasoft.app';
  // static const appstoreId = 'com.apple.mobilesafari';

  @override
  Widget build(BuildContext context) => RateMyAppBuilder(
        rateMyApp: RateMyApp(
          googlePlayIdentifier: playStoreId,
          // appStoreIdentifier: appstoreId,
          minDays: 0,
          minLaunches: 1,
          // remindDays: 1,
          // remindLaunches: 1,
          preferencesPrefix: 'rateMyApp_',
          remindDays: 7,
          remindLaunches: 10,
        ),
        onInitialized: (context, rateMyApp) {
          setState(() => this.rateMyApp = rateMyApp);

          // if (rateMyApp.shouldOpenDialog) {
          rateMyApp.showStarRateDialog(
            context,
            title: 'Enjoying Chamasoft?',
            message: 'Please Rate Chamasoft mobile App.',
            dialogStyle: DialogStyle(
                titleAlign: TextAlign.center,
                messageAlign: TextAlign.start,
                messagePadding: EdgeInsets.only(bottom: 20)),
            // ignoreNativeDialog: Platform.isIOS,
            actionsBuilder: (context, stars) {
              return [
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text('Rate'),
                  onPressed: () {
                    if (stars != null) {
                      //   rateMyApp.d
                      //  rateMyApp.doNotOpenAgain = true;
                      rateMyApp.save().then((v) => Navigator.pop(context));

                      if (stars <= 3) {
                        print('Navigate to Contact Us Screen');
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => ContactUsScreen(),
                        //   ),
                        // );
                      } else if (stars <= 5) {
                        print('Open Google Playstore');
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ];
            },
            starRatingOptions:
                StarRatingOptions(itemColor: Theme.of(context).primaryColor),
          );
          // }
        },
        builder: (context) => rateMyApp == null
            ? Center(child: CircularProgressIndicator())
            : widget.builder(rateMyApp),
      );
}
