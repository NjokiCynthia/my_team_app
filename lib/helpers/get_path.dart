import 'dart:convert';
import 'dart:io';

import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<String> getDirPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return dir.path;
}

Future<void> writeData(String url, String groupId, String userId,
    String newrequestDate, String newResponseDate) async {
  final _dirPath = await getDirPath();
  final _myFile = File('$_dirPath/data.txt');
  // If data.txt doesn't exist, it will be created automatically
  var datatoSave = ("$url $groupId $userId $newrequestDate $newResponseDate\n");
  for (int i = 0; i < 1; i++) {
    await _myFile.writeAsString(datatoSave, mode: FileMode.append);
  }
}

/*
Future <void>  readFileData() async {
  Map<String, dynamic> _formData = {};
  BuildContext context;
  final _dirPath = await getDirPath();
  final logfilePath = File('$_dirPath/data.txt');
  final logDataSaved = await logfilePath.readAsString(encoding: utf8);
  print("saved data on the file is $logDataSaved");

  final _myFile = File('$_dirPath/data.txt');

  print("File size is : ${ await _myFile.length()}");

  if(await _myFile.length() >= 1000){
    print("Hello, its more than 10kb");

    _formData['data'] = logDataSaved;
    try {
      await Provider.of<Groups>(context, listen: false).recordLogAPIs(_formData);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(context:context, error:error, */
/*callback: () {
        Navigator.of(context).pop();
      }*//*
);
    }
    print("Data saved to the server");
    // readFileData();

  }
  else{
    print("Hello, its less than 10kb");
    // readFileData();
  }
}*/
