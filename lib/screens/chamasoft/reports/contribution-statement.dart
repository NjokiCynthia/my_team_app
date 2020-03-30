import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../dashboard.dart';

class ContributionStatement extends StatefulWidget {
  @override
  _ContributionStatementState createState() => _ContributionStatementState();
}

class _ContributionStatementState extends State<ContributionStatement> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }

    @override
    void initState(){
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            screenActionButton(
              icon: LineAwesomeIcons.arrow_left,
              backgroundColor: Colors.blue.withOpacity(0.1),
              textColor: Colors.blue,
              action: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ChamasoftDashboard(),
                ),
              ),
            ),
            SizedBox(width: 20.0),
            heading2(color: Colors.blue, text: "Contribution Statement"),
          ],
        ),
        elevation: _appBarElevation,
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
