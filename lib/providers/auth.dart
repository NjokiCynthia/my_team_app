import 'dart:convert';

import 'package:chamasoft/utilities/post-to-server.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../utilities/custom-helper.dart';

class Auth with ChangeNotifier {
  Future<void> generatePin(String identity) async {
    const url = CustomHelper.baseUrl + CustomHelper.generatePin;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildNumber = packageInfo.buildNumber;
    final Map<String, String> headers = {
      "Versioncode": buildNumber,
      "Authorization": "abcdefghhgfedcba",
      "Secret": "abcdefghhgfedcba",
    };
    final postRequest = json.encode({
      "identity": identity,
    });
    await PostToServer.post(postRequest);

    // final http.Response response = await http.post(url,headers:headers,body:postRequest);
    // print(response.body);
  }
}
