import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/statement-row.dart';
import 'package:chamasoft/screens/chamasoft/reports/member/detail-member-statement.dart';
import 'package:chamasoft/screens/pdfAPI.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/data-loading-effects.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/listviews.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
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
  String _email, _phone, _role, _memberName;
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

    // _contributionStatementModel =
    //     Provider.of<Groups>(context, listen: false).getContributionStatements;

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
      _memberName = _contributionStatementModel.memberName;
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
            _memberName = _contributionStatementModel.memberName;
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

  Future _downloadFinePdf(BuildContext context, Group groupObject) async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = true;
      });
    });

    setState(() async {
      final title = "Fine Payment";
      final pdfFile = await PdfApi.generateFineStatementPdf(
          _statements, _contributionStatementModel, groupObject, title);
      PdfApi.openFile(pdfFile);
      _isLoading = false;
    });
  }

  // Future _downloadFinePdf(BuildContext context, [Group groupObject]) async {
  //   final title = "Fine Payment";
  //   final pdfFile = await PdfApi.generateFineStatementPdf(
  //       _statements, _contributionStatementModel, groupObject, title);
  //   PdfApi.openFile(pdfFile);
  // }

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    return Scaffold(
      key: _scaffoldKey,
      appBar: tertiaryPageAppbar(
          context: context,
          title: "Fine Statements",
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
          trailingIcon: LineAwesomeIcons.download,
          trailingAction: () => _downloadFinePdf(context, groupObject)),
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
                            text: _memberName != null ? _memberName : '--',
                            // fontSize: 16.0,
                            // ignore: deprecated_member_use
                            color:
                                // ignore: deprecated_member_use
                                Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
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
                                Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
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
                                Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
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
                                Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor,
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
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color:
                            // ignore: deprecated_member_use
                            Theme.of(context)
                                .textSelectionTheme
                                .selectionHandleColor,
                        textAlign: TextAlign.start,
                      ),
                      subtitle2(
                        text: _statementAsAt,
                        fontSize: 12,
                        // fontWeight: FontWeight.w500,
                        color:
                            // ignore: deprecated_member_use
                            Theme.of(context)
                                .textSelectionTheme
                                .selectionHandleColor,
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
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Theme.of(context)
                              // ignore: deprecated_member_use
                              .textSelectionTheme
                              .selectionHandleColor,
                          textAlign: TextAlign.end,
                        ),
                        subtitle2(
                          fontSize: 12,
                          //  fontWeight: FontWeight.w500,
                          text: _statementFrom.isNotEmpty
                              ? "$_statementFrom to $_statementTo"
                              : "",
                          color: Theme.of(context)
                              // ignore: deprecated_member_use
                              .textSelectionTheme
                              .selectionHandleColor,
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
            Container(
              padding:
                  EdgeInsets.only(left: 8.0, top: 0.0, right: 8.0, bottom: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: subtitle3(
                        text: "Date",
                        color: Theme.of(context).primaryColor,
                        textAlign: TextAlign.start),
                  ),
                  Expanded(
                    flex: 1,
                    child: subtitle3(
                        text: 'Due (${groupObject.groupCurrency})',
                        color: Theme.of(context).primaryColor,
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 1,
                    child: subtitle3(
                        text: 'Paid (${groupObject.groupCurrency})',
                        color: Theme.of(context).primaryColor,
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 1,
                    child: subtitle3(
                        text: 'Bal (${groupObject.groupCurrency})',
                        color: Theme.of(context).primaryColor,
                        textAlign: TextAlign.end),
                  ),
                ],
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

                            return Container(
                              color: (index % 2 == 0)
                                  ? (themeChangeProvider.darkTheme)
                                      ? Colors.blueGrey[800]
                                      : Color(0xffededfe)
                                  : Theme.of(context).backgroundColor,
                              padding: EdgeInsets.only(
                                  left: 0.0, top: 0.0, right: 0.0, bottom: 5.0),
                              child: InkWell(
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
                                                  memberName:
                                                      widget.memberNames,
                                                  recieptTitle: currentLanguage ==
                                                          'English'
                                                      ? 'Fine Statement'
                                                      : Provider.of<TranslationProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .translate(
                                                                  'Fine statement') ??
                                                          'Fine statement',
                                                  // "Fine Statement",
                                                  group: groupObject)));
                                },
                              ),
                            );
                          },
                          itemCount: _statements.length,
                        ),
                      )
                    : emptyList(
                        color: Colors.blue[400],
                        iconData: LineAwesomeIcons.file,
                        text:
                            "There are no fine statements for ${widget.memberNames}")),
            SizedBox(
              height: 10,
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 8.0, top: 0.0, right: 8.0, bottom: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: subtitle1(
                        text: "Total",
                        color: Theme.of(context).primaryColor,
                        textAlign: TextAlign.start),
                  ),
                  Expanded(
                    flex: 1,
                    child: subtitle3(
                        text: currencyFormat.format(_totalDue),
                        color: Theme.of(context).primaryColor,
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 1,
                    child: subtitle3(
                        text: currencyFormat.format(_totalContributions),
                        color: Theme.of(context).primaryColor,
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 1,
                    child: subtitle3(
                        text: currencyFormat.format(_balance),
                        color: (_balance > 0)
                            ? Colors.red
                            : (_balance < 0
                                ? Colors.green
                                // ignore: deprecated_member_use
                                : Theme.of(context)
                                    .textSelectionTheme
                                    .selectionHandleColor),
                        textAlign: TextAlign.end),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                children: [
                  Center(
                    child: subtitle3(
                      text: _balance < 0
                          ? "You have an Overpayment of ${groupObject.groupCurrency + " " + currencyFormat.format(_balance.abs())}"
                          : "You have an Underpayment of ${groupObject.groupCurrency + " " + currencyFormat.format(_balance.abs())}",
                      textAlign: TextAlign.start,
                      //fontSize: 14.0,
                      // ignore: deprecated_member_use
                      color:
                          // ignore: deprecated_member_use
                          Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor,
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
