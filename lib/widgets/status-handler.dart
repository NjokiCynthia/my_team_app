import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dialogs.dart';

class StatusHandler {
  void handleStatus(BuildContext context, HttpException exception) {
    switch (exception.status) {
      case ErrorStatusCode.statusNormal:
        showErrorDialog(context, "Hello" + exception.toString());
        break;
      case ErrorStatusCode.statusRequireLogout:
        Navigator.of(context).pushReplacementNamed('/');
        Provider.of<Auth>(context, listen: false).logout();
        break;
      case ErrorStatusCode.statusRequireRestart:
        break;
      default:
        break;
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    alertDialog(context, message);
  }
}
