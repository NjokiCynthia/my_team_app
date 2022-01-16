import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class FeedBackForm extends StatefulWidget {
  const FeedBackForm({Key key}) : super(key: key);

  @override
  _FeedBackFormState createState() => _FeedBackFormState();
}

class _FeedBackFormState extends State<FeedBackForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isInit = true;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: secondaryPageAppbar(
          context: context,
          title: "Feedback",
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            subtitle1(text: 'Name', textAlign: TextAlign.start),
            simpleTextInputField(context: context, labelText: 'eg. Joh Doe'),
            SizedBox(
              height: 10,
            ),
            subtitle1(text: 'Email', textAlign: TextAlign.start),
            simpleTextInputField(
                context: context, labelText: 'eg. user@gmail.com'),
            SizedBox(
              height: 10,
            ),
            subtitle1(text: 'Subject', textAlign: TextAlign.start),
            simpleTextInputField(context: context, labelText: 'eg. My Subject'),
            SizedBox(
              height: 10,
            ),
            subtitle1(text: 'Messages', textAlign: TextAlign.start),
            Center(
                child: multilineTextField(
                    context: context, labelText: 'eg. My Message')),
            SizedBox(
              height: 10,
            ),
            _isLoading
                ? Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : defaultButton(
                    context: context,
                    text: "SAVE",
                    onPressed: () {
                      print("this is clicked");
                      // _submit(context);
                    })
          ],
        ),
      ),
    );
  }
}
