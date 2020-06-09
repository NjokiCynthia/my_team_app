import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/screens/login.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/dialogs.dart';

class StatusHandler {
  void handleStatus(BuildContext context, CustomException exception) {
    switch (exception.status) {
      case ErrorStatusCode.statusNormal:
        showErrorDialog(context, "Hello ere" + exception.message);
        break;
      case ErrorStatusCode.statusRequireLogout:
        logout(context);
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

  void logout(BuildContext context) {
    Provider.of<Auth>(context, listen: false).logout();
    Navigator.of(context).pushNamedAndRemoveUntil(Login.namedRoute, ModalRoute.withName("/"));
  }
}
