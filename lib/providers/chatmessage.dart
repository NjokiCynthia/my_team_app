import 'package:flutter/material.dart';
//import 'package:get/get_connect/sockets/src/socket_notifier.dart';

class Message {
  String messageContent;
  bool isSentbyMe;
  DateTime dateTime;

  Message(this.messageContent, this.isSentbyMe, this.dateTime);
}

class ChatMessage extends ChangeNotifier {
  List<Message> _chatMessages = [
    Message("Hello how can we help with EazzyClub?", false, DateTime.now()),
    Message("I want to create a loan, how do I apply for one", true,
        DateTime.now().subtract(Duration(minutes: 1))),
    Message(
        "You will have to register with us, then we will later take you through the process",
        false,
        DateTime.now().subtract(Duration(minutes: 2))),
  ];

  List<Message> get chatMessages {
    return _chatMessages;
  }

  void addChatMessage(Message newMessage) {
    _chatMessages.add(newMessage);
    notifyListeners();
  }
}
