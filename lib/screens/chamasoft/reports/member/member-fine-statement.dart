import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/detail-member-statement.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class MemberFineStatement extends StatefulWidget {
  final String memberNames, memberIds, memberPhoto;
  const MemberFineStatement(
      {Key key, this.memberIds, this.memberNames, this.memberPhoto})
      : super(key: key);

  @override
  _MemberFineStatementState createState() => _MemberFineStatementState();
}

class _MemberFineStatementState extends State<MemberFineStatement> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _appBarElevation = 0;
  ScrollController _scrollController;
  bool _isInit = true;
  bool _isLoading = true;
  double _totalContributions = 0;
  double _totalDue = 0;
  double _balance = 0;
  bool _hasMoreData;
  String _statementAsAt = '', _statementFrom = '', _statementTo = '';
  String _email, _phone, _role;
  List<ContributionStatementRow> _statements = [];
  ContributionStatementModel _contributionStatementModel;

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? _appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  Future<void> _fetchMemberfineStatement(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchMemberFineStatement(memberId: widget.memberIds);
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchMemberfineStatement(context);
          },
          scaffoldState: _scaffoldKey.currentState);
    }
  }

  Future<bool> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    _contributionStatementModel =
        Provider.of<Groups>(context, listen: false).getContributionStatements;

    if (_contributionStatementModel != null) {
      _statements = _contributionStatementModel.statements;
      _totalContributions = _contributionStatementModel.totalPaid;
      _totalDue = _contributionStatementModel.totalDue;
      _balance = _contributionStatementModel.totalBalance;
      _statementAsAt = _contributionStatementModel.statementAsAt;
      _statementFrom = _contributionStatementModel.statementFrom;
      _statementTo = _contributionStatementModel.statementTo;
      _role = _contributionStatementModel.role;
      _phone = _contributionStatementModel.phone;
      _email = _contributionStatementModel.email;
    }

    _fetchMemberfineStatement(context).then((_) {
      if (context != null) {
        _contributionStatementModel =
            Provider.of<Groups>(context, listen: false)
                .getContributionStatements;

        setState(() {
          _isLoading = false;
          if (_contributionStatementModel != null) {
            _statements = _contributionStatementModel.statements;
            _totalContributions = _contributionStatementModel.totalPaid;
            _totalDue = _contributionStatementModel.totalDue;
            _balance = _contributionStatementModel.totalBalance;
            _statementAsAt = _contributionStatementModel.statementAsAt;
            _statementFrom = _contributionStatementModel.statementFrom;
            _statementTo = _contributionStatementModel.statementTo;
            _role = _contributionStatementModel.role;
            _phone = _contributionStatementModel.phone;
            _email = _contributionStatementModel.email;
          }
        });
      }
    });

    _isInit = false;
    return true;
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
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Scaffold(
      key: _scaffoldKey,
      appBar: secondaryPageAppbar(
          context: context,
          title: "Fine Statements",
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left),
      backgroundColor: Theme.of(context).backgroundColor,
      body: RefreshIndicator(
        backgroundColor: (themeChangeProvider.darkTheme)
            ? Colors.blueGrey[800]
            : Colors.white,
        onRefresh: () => _fetchData(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              color: (themeChangeProvider.darkTheme)
                  ? Colors.blueGrey[800]
                  : Color(0xffededfe),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  widget.memberPhoto != null
                      ? Container(
                          height: 70,
                          width: 75,
                          child: new CachedNetworkImage(
                            imageUrl: widget.memberPhoto,
                            placeholder: (context, url) => const CircleAvatar(
                              backgroundImage:
                                  const AssetImage('assets/no-user.png'),
                            ),
                            imageBuilder: (context, image) => CircleAvatar(
                              backgroundImage: image,
                            ),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              backgroundImage:
                                  const AssetImage('assets/no-user.png'),
                            ),
                            fadeOutDuration: const Duration(seconds: 1),
                            fadeInDuration: const Duration(seconds: 3),
                          ),
                        )
                      : const CircleAvatar(
                          backgroundImage:
                              const AssetImage('assets/no-user.png'),
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!_isLoading &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            _hasMoreData) {
                          // ignore: todo
                          //TODO check if has more data before fetching again
                          _fetchData();
                        }
                        return true;
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          heading3(
                            text: widget.memberNames,
                            // fontSize: 16.0,
                            // ignore: deprecated_member_use
                            color:
                                // ignore: deprecated_member_use
                                Theme.of(context).textSelectionHandleColor,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          customTitle(
                            text: _role != null ? _role : '--',
                            textAlign: TextAlign.start,
                            fontSize: 16.0,
                            // ignore: deprecated_member_use
                            color:
                                // ignore: deprecated_member_use
                                Theme.of(context).textSelectionHandleColor,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          subtitle2(
                            text: _phone != null ? _phone : '--',
                            textAlign: TextAlign.start,
                            // ignore: deprecated_member_use
                            color:
                                // ignore: deprecated_member_use
                                Theme.of(context).textSelectionHandleColor,
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          subtitle2(
                            text: _email != null ? _email : '--',
                            textAlign: TextAlign.start,
                            // ignore: deprecated_member_use
                            color:
                                // ignore: deprecated_member_use
                                Theme.of(context).textSelectionHandleColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            _isLoading
                ? showLinearProgressIndicator()
                : SizedBox(
                    height: 0.0,
                  ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      customTitle(
                        text: "Fine Statement as At",
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color:
                            // ignore: deprecated_member_use
                            Theme.of(context).textSelectionHandleColor,
                        textAlign: TextAlign.start,
                      ),
                      customTitle(
                        text: _statementAsAt,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color:
                            // ignore: deprecated_member_use
                            Theme.of(context).textSelectionHandleColor,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        customTitle(
                          text: "Fine Statement Period",
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Theme.of(context)
                              // ignore: deprecated_member_use
                              .textSelectionHandleColor,
                          textAlign: TextAlign.end,
                        ),
                        customTitle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          text: _statementFrom.isNotEmpty
                              ? "$_statementFrom to $_statementTo"
                              : "",
                          color: Theme.of(context)
                              // ignore: deprecated_member_use
                              .textSelectionHandleColor,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: EdgeInsets.all(8.0),
                color: (themeChangeProvider.darkTheme)
                    ? Color(0xffededfe)
                    : Theme.of(context).primaryColor,
                //color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 100.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customTitle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            text: 'Date',
                            color: Colors.white,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.71,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 2,
                          ),
                          customTitle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            text: 'Due (${groupObject.groupCurrency})',
                            color: Colors.white,
                            textAlign: TextAlign.start,
                          ),
                          customTitle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            text: 'Paid (${groupObject.groupCurrency})',
                            color: Colors.white,
                            textAlign: TextAlign.start,
                          ),
                          customTitle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            text: 'Bal (${groupObject.groupCurrency})',
                            color: Colors.white,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: _statements.length > 0
                    ? NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (!_isLoading &&
                              scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent) {
                            _fetchData();
                          }
                          return true;
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            ContributionStatementRow row = _statements[index];

                            return InkWell(
                              child: MemberStatementBody(row: row),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new MemberDetailStatement(
                                                groupName:
                                                    groupObject.groupName,
                                                groupEmail:
                                                    groupObject.groupEmail,
                                                groupPhone:
                                                    groupObject.groupPhone,
                                                amount: row.amount,
                                                payable: row.payable,
                                                singleBalance: row.balance,
                                                date: row.date,
                                                title: row.title,
                                                description: row.description,
                                                memberName: widget.memberNames,
                                                recieptTitle: "Fine Statement",
                                                group: groupObject)));
                              },
                            );
                          },
                          itemCount: _statements.length,
                        ),
                      )
                    : emptyList(
                        color: Colors.blue[400],
                        iconData: LineAwesomeIcons.file_text,
                        text:
                            "There are no fine statements for ${widget.memberNames}")),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 100.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customTitle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            text: 'Total',
                            color: Colors.white,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.71,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 2,
                          ),
                          customTitle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            text: groupObject.groupCurrency +
                                " " +
                                currencyFormat.format(_totalDue),
                            color: Colors.white,
                            textAlign: TextAlign.end,
                          ),
                          customTitle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            text: groupObject.groupCurrency +
                                " " +
                                currencyFormat.format(_totalContributions),
                            color: Colors.white,
                            textAlign: TextAlign.end,
                          ),
                          customTitle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            text: groupObject.groupCurrency +
                                " " +
                                currencyFormat.format(_balance),
                            color: Colors.white,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                children: [
                  Center(
                    child: customTitle(
                      text: _balance < 0
                          ? "You have an Overpayment of ${groupObject.groupCurrency + " " + currencyFormat.format(_balance.abs())}"
                          : "You have an Underpayment of ${groupObject.groupCurrency + " " + currencyFormat.format(_balance.abs())}",
                      textAlign: TextAlign.start,
                      fontSize: 14.0,
                      // ignore: deprecated_member_use
                      color:
                          // ignore: deprecated_member_use
                          Theme.of(context).textSelectionHandleColor,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }
}