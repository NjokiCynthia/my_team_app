import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/screens/intro.dart';
import 'package:chamasoft/screens/login.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/dialogs.dart';

class StatusHandler {
  void handleStatus({BuildContext context, CustomException error, VoidCallback callback}) {
    switch (error.status) {
      case ErrorStatusCode.statusNormal:
        showErrorDialog(context, error.message);
        break;
      case ErrorStatusCode.statusRequireLogout:
        logout(context);
        break;
      case ErrorStatusCode.statusRequireRestart:
        restartApp(context);
        break;
      case ErrorStatusCode.statusNoInternet:
        showRetrySnackBar(context, error.message, callback);
        break;
      case ErrorStatusCode.statusFormValidationError:
        showErrorDialogWithTitle(context, error.message, "Some values are missing");
        break;
      default:
        break;
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    alertDialog(context, message);
  }

  void showErrorDialogWithTitle(BuildContext context, String message, String title) {
    alertDialog(context, message, title);
  }

  void showRetrySnackBar(BuildContext context, String message, VoidCallback voidCallback) {
    final snackBar = SnackBar(
      content: subtitle2(text: message, textAlign: TextAlign.start),
      action: SnackBarAction(
        label: "Retry",
        onPressed: () => voidCallback(),
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  void restartApp(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(IntroScreen.namedRoute, ModalRoute.withName("/"));
    //Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  void logout(BuildContext context) {
    Provider.of<Auth>(context, listen: false).logout();
    Navigator.of(context).pushNamedAndRemoveUntil(Login.namedRoute, ModalRoute.withName("/"));
  }
}
