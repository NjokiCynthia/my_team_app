import 'package:flutter/material.dart';
import 'package:crisp/crisp_view.dart';
import 'package:crisp/models/main.dart';
import 'package:crisp/models/user.dart';

class ChatWithContactSupportScreen extends StatefulWidget {
  @override
  _ChatWithContactSupportScreenState createState() =>
      _ChatWithContactSupportScreenState();
}

class _ChatWithContactSupportScreenState
    extends State<ChatWithContactSupportScreen> {
  CrispMain crispMain;

  @override
  void initState() {
    super.initState();

    crispMain = CrispMain(
      websiteId: 'cb69e281-2d9e-4f3d-a4d3-cdd94f1b27b7',
      locale: 'en',
    );

    crispMain.register(
      user: CrispUser(
        email: "leo@provider.com",
        avatar: 'https://avatars2.githubusercontent.com/u/16270189?s=200&v=4',
        nickname: "João Cardoso",
        phone: "5511987654321",
      ),
    );

    crispMain.setMessage("Hello world");

    crispMain.setSessionData({
      "order_id": "111",
      "app_version": "0.1.1",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CrispView(
          crispMain: crispMain,
          clearCache: false,
        ),
      ),
    );
  }
}
