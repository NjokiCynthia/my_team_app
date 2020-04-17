import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.red,
            child: Center(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        heading1(
                            text: "Update Profile",
                            color: Theme.of(context).textSelectionHandleColor),
                        subtitle2(
                            text: "Update your Chamasoft Profile",
                            color: Theme.of(context).textSelectionHandleColor),
                        Image(
                          image: AssetImage('assets/no-user.png'),
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                  heading2(
                      text: "Edwin Kapkei",
                      color: Theme.of(context).textSelectionHandleColor),
                  subtitle2(
                      text: "+254 701 234 567",
                      color: Theme.of(context).textSelectionHandleColor),
                  ListTile(
                    title: Text("Group Settings",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Theme.of(context).textSelectionHandleColor,
                        )),
                    subtitle: Text(
                      "Witcher Welfare Association",
                      style:
                          TextStyle(color: Theme.of(context).bottomAppBarColor),
                    ),
                    trailing: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Theme.of(context)
                            .bottomAppBarColor
                            .withOpacity(0.6),
                      ),
                    ),
                    dense: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
