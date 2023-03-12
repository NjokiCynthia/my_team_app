import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TempolaryPin extends StatefulWidget {
  //const TempolaryPin({ Key? key }) : super(key: key);

  @override
  _TempolaryPinState createState() => _TempolaryPinState();
}

class _TempolaryPinState extends State<TempolaryPin> {
  List<String> currentPin = ["", "", "", ""];
  TextEditingController currentPin1 = TextEditingController();
  TextEditingController currentPin2 = TextEditingController();
  TextEditingController currentPin3 = TextEditingController();
  TextEditingController currentPin4 = TextEditingController();

  var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.transparent));

  int pinIndex = 0;

  bool loading = false;

  void pinIndexSetup(String s, BuildContext context) async {
    if (pinIndex == 0) {
      pinIndex = 1;
    } else if (pinIndex < 4) pinIndex++;
    setPin(pinIndex, s);
    currentPin[pinIndex - 1] = s;
    String strpin = "";
    currentPin.forEach((element) {
      strpin += element;
    });
    if (pinIndex == 4) {
      print(strpin);
      print('Final Submission...');

      if (strpin != '1234') {
        Fluttertoast.showToast(msg: "Incorrect Password");
      } else {
        // context.loaderOverlay.show();
        final overlay = LoadingOverlay.of(context);
        overlay.during();
      }
    }
  }

  setPin(int /*pinIndex*/ n, String s) {
    switch (n) {
      case 1:
        currentPin1.text = s;
        break;
      case 2:
        currentPin2.text = s;
        break;
      case 3:
        currentPin3.text = s;
        break;
      case 4:
        currentPin4.text = s;
        break;
    }
  }

  void clearPin() {
    //_showToast(context);

    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == 5) {
      setPin(pinIndex, " ");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    } else {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    }
  }

  buildPinRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: currentPin1,
        ),
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: currentPin2,
        ),
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: currentPin3,
        ),
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: currentPin4,
        ),
      ],
    );
  }

  buildNumberPad(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.all(0.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyBoardNumber(
                    n: 1,
                    onPressed: () {
                      pinIndexSetup("1", context);
                    },
                  ),
                  KeyBoardNumber(
                    n: 2,
                    onPressed: () {
                      pinIndexSetup("2", context);
                    },
                  ),
                  KeyBoardNumber(
                    n: 3,
                    onPressed: () {
                      pinIndexSetup("3", context);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyBoardNumber(
                    n: 4,
                    onPressed: () {
                      pinIndexSetup("4", context);
                    },
                  ),
                  KeyBoardNumber(
                    n: 5,
                    onPressed: () {
                      pinIndexSetup("5", context);
                    },
                  ),
                  KeyBoardNumber(
                    n: 6,
                    onPressed: () {
                      pinIndexSetup("6", context);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyBoardNumber(
                    n: 7,
                    onPressed: () {
                      pinIndexSetup("7", context);
                    },
                  ),
                  KeyBoardNumber(
                    n: 8,
                    onPressed: () {
                      pinIndexSetup("8", context);
                    },
                  ),
                  KeyBoardNumber(
                    n: 9,
                    onPressed: () {
                      pinIndexSetup("9", context);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 60.0,
                    child: MaterialButton(
                      height: 60.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      onPressed: () {},
                      // child: Image.asset(
                      //   "assets/images/check.png",
                      //   color: Colors.black,
                      // ),
                    ),
                  ),
                  KeyBoardNumber(
                    n: 0,
                    onPressed: () {
                      pinIndexSetup("0", context);
                    },
                  ),
                  Container(
                    width: 60.0,
                    child: MaterialButton(
                      height: 60.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      onPressed: () {
                        clearPin();
                      },
                      child: Image.asset(
                        "assets/images/backspace.png",
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        /* padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildSecurityText(),
            SizedBox(height: 40.0),
            buildPinRow()
          ],
        ),*/
      ),
    );
  }

  buildSecurityText() {
    return subtitle1(
      text: "Please enter the code that you recieved via sms. ",
      color: Theme.of(context)
          // ignore: deprecated_member_use
          .textSelectionTheme
          .selectionHandleColor
          .withOpacity(0.6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            decoration: primaryGradient(context),
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              top: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment(0, 0.5),
                      margin: EdgeInsets.only(top: 50.0),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildSecurityText(),
                          SizedBox(
                            height: 10.0,
                          ),
                          buildPinRow(),
                          LoaderOverlay(
                            useDefaultLoading: false,
                            child: Text(''),
                            overlayWidget: Text(''),
                            overlayOpacity: 0.2,
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          buildNumberPad(context),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }));
  }
}

class LoadingOverlay {
  BuildContext _context;

  void hide() {
    Navigator.of(_context).pop();
  }

  void show() {
    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (_context) => _FullScreenLoader());
  }

  void during<T>() {
    show();
    // return future.whenComplete(() => hide());
  }

  LoadingOverlay._create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }
}

class _FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
        child: Center(child: CircularProgressIndicator()));
  }
}

class PinNumber extends StatelessWidget {
  // const PinNumber({Key? key}) : super(key: key);

  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;

  PinNumber({this.textEditingController, this.outlineInputBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      padding: EdgeInsets.all(0.0),
      child: TextField(
        controller: textEditingController,
        enabled: true,
        obscureText: true,
        showCursor: true,
        readOnly: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          border: outlineInputBorder,
          filled: true,
          fillColor: Colors.white38,
        ),
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 21.0, color: Colors.black45),
      ),
    );
  }
}

class KeyBoardNumber extends StatelessWidget {
  //const KeyBoardNumber({Key? key}) : super(key: key);

  final int n;

  final Function() onPressed;

  KeyBoardNumber({this.n, this.onPressed});

  /* KeyBoardNumber({this.n, this.onPressed});*/

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primaryColor.withOpacity(0.1),
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        padding: EdgeInsets.all(8.0),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.0),
        ),
        height: 90.0,
        child: Text(
          "$n",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24 * MediaQuery.of(context).textScaleFactor,
            color: Colors.blueGrey[800].withOpacity(0.8),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
