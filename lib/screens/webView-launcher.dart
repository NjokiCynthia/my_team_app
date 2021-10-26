import 'dart:async';

import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewLauncher extends StatefulWidget {
  //WebViewLauncher(String helpUrl);
  String helpUrl;

  WebViewLauncher({Key key, this.helpUrl}) : super(key: key);

  @override
  _WebViewLauncherState createState() => _WebViewLauncherState();
}

class _WebViewLauncherState extends State<WebViewLauncher> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  WebViewController _webViewController;
  bool _isLoading = true;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
          context: context,
          title: "Help Page",
          action: () => Navigator.of(context).pop(),
          elevation: 1,
          leadingIcon: LineAwesomeIcons.arrow_left),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.helpUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {
              setState(() {
                _isLoading = true;
              });
              print("WebView is loading (progress : $progress%)");
            },
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel(context),
            },
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
              });
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
              setState(() {
                _isLoading = false;
              });
            },
            gestureNavigationEnabled: true,
          ),
          _isLoading ? showLinearProgressIndicator() : Stack(),
        ],
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
