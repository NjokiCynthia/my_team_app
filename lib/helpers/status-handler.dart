import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/intro.dart';
import 'package:chamasoft/screens/login.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/dialogs.dart';

class StatusHandler {
  void handleStatus(
      {BuildContext context,
      CustomException error,
      VoidCallback callback,
      ScaffoldState scaffoldState}) {
    switch (error.status) {
      case ErrorStatusCode.statusNormal:
        // showErrorDialog(context, error.message);
        showRetrySnackBar(context, error.message, callback);

        break;
      case ErrorStatusCode.statusRequireLogout:
        logout(context);
        break;
      case ErrorStatusCode.statusRequireRestart:
        restartApp(context);
        break;
      case ErrorStatusCode.statusNoInternet:
        if (scaffoldState != null) {
          showSpecialRetrySnackBar(context,scaffoldState, error.message, callback);
        } else
          showRetrySnackBar(context, error.message, callback);
        break;
      case ErrorStatusCode.statusFormValidationError:
        showErrorDialogWithTitle(
            context, error.message, "Some values are missing");
        break;
      default:
        break;
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    alertDialog(context, message);
  }

  void showDialogWithAction(
      {BuildContext context,
      String message,
      Function function,
      bool dismissible = false}) {
    alertDialogWithAction(context, message, function, dismissible);
  }

  void showErrorDialogWithTitle(
      BuildContext context, String message, String title) {
    alertDialog(context, message, title);
  }

  void showRetrySnackBar(
      BuildContext context, String message, VoidCallback voidCallback) {
    final snackBar = SnackBar(
      content: customTitleWithWrap(text: message, textAlign: TextAlign.start),
      action: SnackBarAction(
        label: "Retry",
        onPressed: () => voidCallback(),
      ),
    );

 
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSpecialRetrySnackBar(
      BuildContext context, ScaffoldState scaffoldState, String message, VoidCallback voidCallback) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 10),
      content: customTitleWithWrap(text: message, textAlign: TextAlign.start),
      action: SnackBarAction(
        label: "Retry",
        onPressed: () => voidCallback(),
      ),
    );


    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void restartApp(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        IntroScreen.namedRoute, ModalRoute.withName("/"));
    //Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  void logout(BuildContext context) async {
    await Provider.of<Auth>(context, listen: false).logout();
    await Navigator.of(context)
        .pushNamedAndRemoveUntil(Login.namedRoute, ModalRoute.withName("/"));
    Provider.of<Groups>(context, listen: false)
        .switchGroupValuesToDefault(removeGroups: true);
  }

  void showSuccessSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: Duration(milliseconds: 2500),
      content: customTitleWithWrap(text: message, textAlign: TextAlign.start),
    );
   
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
