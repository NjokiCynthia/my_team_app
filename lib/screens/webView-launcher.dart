import 'dart:async';

import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class WebViewLauncher extends StatefulWidget {
  //WebViewLauncher(String helpUrl);
  String helpUrl;
  String type;

  WebViewLauncher({Key key, this.helpUrl, this.type}) : super(key: key);

  @override
  _WebViewLauncherState createState() => _WebViewLauncherState();
}

class _WebViewLauncherState extends State<WebViewLauncher> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  // ignore: unused_field
  WebViewController _webViewController;

  bool _isLoading = true;
  String _title = "Chamasoft Help Center";

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    if (widget.type == 'help')
      _title = "Documentations and FAQS";
    else if (widget.type == 'about')
      _title = "About Chamasoft";
    else if (widget.type == 'terms') _title = "Terms and Conditions";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
          context: context,
          title: "$_title",
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
        
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
