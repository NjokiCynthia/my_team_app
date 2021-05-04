import 'package:chamasoft/utilities/database-helper.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

final dbHelper = DatabaseHelper.instance;
Map<String, dynamic> myGroups = {};

double appBarElevation = 2.5;

//launch any url through default browser
launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<bool> entryExistsInDb(
  String table,
  String field,
  String value,
) async {
  var checkRecord = await dbHelper.queryWhere(
    table,
    field,
    [value],
  );
  if (checkRecord.isEmpty) return false;
  return true;
}

Future<dynamic> insertToLocalDb(
  String table,
  Map<String, dynamic> row,
) async {
  return await dbHelper.insert(row, table);
}

Future<dynamic> updateInLocalDb(
  String table,
  Map<String, dynamic> row,
) async {
  return await dbHelper.update(row, table);
}

//get from shared preferences
Future getPreference(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getString(key) ?? '';
  return value;
}

//save to shared preferences
Future setPreference(String key, dynamic data) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, data);
}

//TODO: this is a temporary fix
TextStyle inputTextStyle() {
  return TextStyle(fontFamily: 'SegoeUI');
}

//Edge insets for scrolling input pages
const inputPagePadding =
    EdgeInsets.fromLTRB(SPACING_NORMAL, SPACING_NORMAL, SPACING_NORMAL, 0.0);

final currencyFormat = new NumberFormat("#,##0", "en_US");
final defaultDateFormat = new DateFormat("d MMM, y");

//Padding and margin
const double SPACING_NORMAL = 16.0;
const double SPACING_LARGE = 20.0;
const double SPACING_HUGE = 24.0;

const int CONTRIBUTION_STATEMENT = 1;
const int FINE_STATEMENT = 2;
const int REVIEW_LOAN = 1;
const int VIEW_APPLICATION_STATUS = 2;

//Error messages and codes
const String ERROR_MESSAGE =
    "We could not complete your request at the moment. Try again later";
const String ERROR_MESSAGE_LOGIN = "Kindly login again";
const String ERROR_MESSAGE_INTERNET = "No internet connection";

//Image upload quality
const int IMAGE_QUALITY = 50;

enum SettingActions {
  actionAdd,
  actionEdit,
  actionHide,
  actionUnHide,
  actionDelete
}

enum ErrorStatusCode {
  statusNormal,
  statusRequireLogout, //logout the current user
  statusRequireRestart, //remove the current group loaded on shared preferences and clear screens to restart
  statusNoInternet,
  statusFormValidationError
}
