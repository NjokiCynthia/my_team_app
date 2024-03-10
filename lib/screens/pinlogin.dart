import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/screens/security_question.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PinLogin extends StatefulWidget {
  static const namedRoute = "/pinlogin";

  @override
  _PinLoginState createState() => _PinLoginState();
}

class _PinLoginState extends State<PinLogin> {
  List<String> currentPin = ["", "", "", ""];
  TextEditingController currentPin1 = TextEditingController();
  TextEditingController currentPin2 = TextEditingController();
  TextEditingController currentPin3 = TextEditingController();
  TextEditingController currentPin4 = TextEditingController();
  Auth auth;

  var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.transparent));

  int pinIndex = 0;

  bool loading = false;

  @override
  void didChangeDependencies() {
    // ignore: todo
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    auth = Provider.of<Auth>(context, listen: false);
  }

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

  void confirmPin() {
    if (currentPin.isEmpty) {
      //print("Pin is required to proceed");

      // Toast.show("Pin is required to proceed", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

      // _showToast(context);
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
                      onPressed: () {
                        confirmPin();
                      },
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

  profileName() {
    return heading2(
      text: auth.userName,
     
      color: Theme.of(context).textSelectionTheme.selectionHandleColor,
    );
  }

  forgortPasswordText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            "Forgot your Pin ?",
            style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 7.0,
        ),
        Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResetPin()),
                  );
                },
                child: Text(
                  "Reset Here!",
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )))
      ],
    );
  }

  buildSecurityText() {
    return subtitle1(
      text: "Please enter your secure pin to proceed",
      color: Theme.of(context)
         
          .textSelectionTheme
          .selectionHandleColor
          .withOpacity(0.6),
    );
  }

  profileImage() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: auth.displayAvatar != null
              ? CachedNetworkImage(
                  imageUrl: auth.displayAvatar,
                  placeholder: (context, url) => const CircleAvatar(
                    radius: 35.0,
                    backgroundImage: const AssetImage('assets/no-user.png'),
                  ),
                  imageBuilder: (context, image) => CircleAvatar(
                    backgroundImage: image,
                    radius: 35.0,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fadeOutDuration: const Duration(seconds: 1),
                  fadeInDuration: const Duration(seconds: 3),
                )
              : const CircleAvatar(
                  backgroundImage: const AssetImage('assets/no-user.png'),
                  radius: 35.0,
                ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // context.loaderOverlay.show();

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(builder: (BuildContext context) {
          // ignore: unnecessary_statements
          ThemeMode.light;
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
                  // Expanded(
                  //   child: Container(
                  //     child: Column(
                  //       mainAxisSize: MainAxisSize.min,
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
                  //         profileImage(),
                  //         SizedBox(
                  //           height: 5.0,
                  //         ),
                  //         profileName(),
                  //       ],
                  //     )
                  //   )
                  // ),
                  Expanded(
                    child: Container(
                      alignment: Alignment(0, 0.5),
                      margin: EdgeInsets.only(top: 50.0),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          profileImage(),
                          SizedBox(
                            height: 5.0,
                          ),
                          profileName(),
                          SizedBox(
                            height: 100.0,
                          ),
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
                  ),
                  forgortPasswordText(),
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
