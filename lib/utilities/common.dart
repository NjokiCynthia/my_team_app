
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

//launch any url through default browser
launchURL(String url) async{
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

//get from shared preferences
Future getPreference(String key) async{
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getString(key) ?? '';
  return value;
}

//save to shared preferences
Future setPreference(String key, dynamic data) async{
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, data);
}
