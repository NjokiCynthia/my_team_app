import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

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
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              heading1(
                  text: "Update Profile",
                  color: Theme.of(context).textSelectionHandleColor),
              subtitle2(
                  text: "Update your Chamasoft Profile",
                  color: Theme.of(context).textSelectionHandleColor),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 150,
                width: 150,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/no-user.png'),
                      backgroundColor: Colors.transparent,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 30.0,
                        ),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                title: Text("Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Theme.of(context).bottomAppBarColor,
                    )),
                subtitle: Text(
                  "Jane Doe",
                  style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor,
                    fontSize: 20.0,
                  ),
                ),
                trailing: MaterialButton(
                  onPressed: () {},
                  color: Colors.blueAccent[100].withOpacity(.2),
                  textColor: Colors.blue,
                  child: Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  padding: EdgeInsets.all(16),
                  shape: CircleBorder(),
                ),
                dense: true,
                onTap: () {},
              ),
              ListTile(
                title: Text("Phone Number",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Theme.of(context).bottomAppBarColor,
                    )),
                subtitle: Text(
                  "+254 701 234 567",
                  style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor,
                    fontSize: 20.0,
                  ),
                ),
                trailing: MaterialButton(
                  onPressed: () {},
                  color: Colors.blueAccent[100].withOpacity(.2),
                  textColor: Colors.blue,
                  child: Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  padding: EdgeInsets.all(16),
                  shape: CircleBorder(),
                ),
                dense: true,
                onTap: () {},
              ),
              ListTile(
                title: Text("Email Address",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Theme.of(context).bottomAppBarColor,
                    )),
                subtitle: Text(
                  "jane.doe@gmail.com",
                  style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor,
                    fontSize: 20.0,
                  ),
                ),
                trailing: MaterialButton(
                  onPressed: () {},
                  color: Colors.blueAccent[100].withOpacity(.2),
                  textColor: Colors.blue,
                  child: Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  padding: EdgeInsets.all(16),
                  shape: CircleBorder(),
                ),
                dense: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
