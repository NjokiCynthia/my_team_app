import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/login.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  bool _loading = true;

  _isFirstTime() async {
    setPreference("currency", "Ksh");

    (await getPreference("isFirstTime") != '')
        ? Navigator.of(context)
            .pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => ChamasoftDashboard()))
            .whenComplete(() {
            _loading = false;
          })
        : setState(() {
            _loading = false;
          });
  }

  @override
  void initState() {
    _isFirstTime();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onIntroEnd(context) {
    setPreference("isFirstTime", "true");
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => Login()));
  }

  Widget _buildImage(String assetName) {
    return Align(
        child: Image.asset('assets/$assetName.png', width: 280.0),
        alignment: Alignment.bottomCenter);
  }

  @override
  Widget build(BuildContext context) {
    PageDecoration _pageDeco({Color pageColor}) {
      return PageDecoration(
          titleTextStyle: TextStyle(
              fontSize: 26.0, fontWeight: FontWeight.w900, color: Colors.white),
          bodyTextStyle: TextStyle(fontSize: 16.0, color: Colors.white),
          descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          titlePadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
          pageColor: pageColor,
          imagePadding: EdgeInsets.zero);
    }

    Widget _pageLoading() {
      return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Center(
              child: CircularProgressIndicator(
            strokeWidth: 3.0,
          )));
    }

    return _loading
        ? _pageLoading()
        : IntroductionScreen(
            key: introKey,
            pages: [
              PageViewModel(
                  titleWidget: heading1(
                      text: "A fix for your Chama", color: Colors.white),
                  bodyWidget: subtitle1(
                      text:
                          "A leading book keeping tool for investment groups that handles all your Chama's financial administration as you focus on your investments.",
                      color: Colors.white),
                  image: _buildImage('onboarding_1'),
                  decoration: _pageDeco(
                    pageColor: Colors.blue[900],
                  )),
              PageViewModel(
                  titleWidget: heading1(
                      text: "...merry-go-rounds too", color: Colors.white),
                  bodyWidget: subtitle1(
                      text:
                          "Send your contributions, manage members, make withdrawals straight to your M-Pesa, and more. It's never been this easy.",
                      color: Colors.white),
                  image: _buildImage('onboarding_2'),
                  decoration: _pageDeco(
                    pageColor: Colors.blue[800],
                  )),
              PageViewModel(
                  titleWidget: heading1(
                      text: "...or even a fundraiser!", color: Colors.white),
                  bodyWidget: subtitle1(
                      text:
                          "Running a fundraiser & in need of a solution for processing contributions? Give your contributors a great experience & hit your target faster.",
                      color: Colors.white),
                  image: _buildImage('onboarding_3'),
                  decoration: _pageDeco(
                    pageColor: Colors.blue[900],
                  ))
            ],
            globalBackgroundColor: Colors.blue[900],
            onDone: () => _onIntroEnd(context),
            //onSkip: () => _onIntroEnd(context),
            showSkipButton: true,
            skipFlex: 0,
            nextFlex: 0,
            skip: Text("Skip",
                style: TextStyle(
                    fontFamily: 'SegoeUI',
                    fontSize: 16.0,
                    color: Colors.blue[200])),
            next: Text("Next",
                style: TextStyle(
                    fontFamily: 'SegoeUI',
                    fontSize: 16.0,
                    color: Colors.white)),
            done: Text("Continue",
                style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'SegoeUI',
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            dotsDecorator: DotsDecorator(
                size: Size(10.0, 10.0),
                color: Colors.blue[200],
                activeSize: Size(16.0, 10.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                activeColor: Colors.white));
  }
}
