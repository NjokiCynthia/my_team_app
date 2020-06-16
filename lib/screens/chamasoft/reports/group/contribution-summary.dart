import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/FilterContainer.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ContributionSummary extends StatefulWidget {
  @override
  _ContributionSummaryState createState() => _ContributionSummaryState();
}

class _ContributionSummaryState extends State<ContributionSummary> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isLoading = true;
  bool _isInit = true;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  void _applyFilter() {}

  void _showFilter(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_) => FilterContainer(ModalRoute.of(context).settings.arguments, _applyFilter));
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
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _fetchGroupContributionSummary(context).then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {});
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _fetchGroupContributionSummary(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).getGroupContributionSummary();
    } catch (error) {
      StatusHandler().handleStatus(context: context, error: error, callback: () {});
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupObject = Provider.of<Groups>(context,listen: false).getCurrentGroup();
    final summaryFlag = ModalRoute.of(context).settings.arguments;
    String appbarTitle = "Contribution Summary";
    String defaultTitle = "Contributions";

    if (summaryFlag == FINE_STATEMENT) {
      appbarTitle = "Fine Summary";
      defaultTitle = "Fines";
    }
    return Scaffold(
      appBar: tertiaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        trailingIcon: LineAwesomeIcons.filter,
        title: appbarTitle,
        trailingAction: () => _showFilter(context),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            color: (themeChangeProvider.darkTheme) ? Colors.blueGrey[800] : Color(0xffededfe),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          heading2(
                            text: groupObject.groupName,
                            color: Theme.of(context).textSelectionHandleColor,
                          ),
                          customTitle(
                            text: "Total " + defaultTitle,
                            color: Theme.of(context).textSelectionHandleColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                          ),
                          customTitle(
                            text: "${groupObject.groupSize} Members",
                            textAlign: TextAlign.start,
                            color: primaryColor,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        customTitle(
                          text: "Ksh ",
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0,
                          color: Theme.of(context).textSelectionHandleColor,
                        ),
                        heading2(
                          text: currencyFormat.format(2000000),
                          color: Theme.of(context).textSelectionHandleColor,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                subtitle2(
                  text: "Statement Period",
                  color: Theme.of(context).textSelectionHandleColor,
                  textAlign: TextAlign.start,
                ),
                subtitle1(
                  text: "12 October 2019 to 20 February 2021",
                  color: Theme.of(context).textSelectionHandleColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 1,
                  child: subtitle1(text: "Paid", color: Theme.of(context).primaryColor, textAlign: TextAlign.end),
                ),
                Expanded(
                  flex: 1,
                  child: subtitle1(text: "Balance", color: Theme.of(context).primaryColor, textAlign: TextAlign.end),
                ),
              ],
            ),
          ),
          Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ContributionSummaryBody())
        ],
      ),
    );
  }
  
}
