          } else
            _hasMoreData = true;
        });
      }

    _isInit = false;
  }

  @override
  void didChangeDependencies() {
    if (_isInit)
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    super.didChangeDependencies();
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

  void applySort(String sort) {
    _sortOption = sort;
    _forceFetch = true;
    _fetchData();
  }

  void showSortBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => SortContainer(_sortOption, applySort));
  }

  void showFilterOptions() async {
    List<dynamic> filters = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return FilterContainer(
        filterType: 1,
        currentFilters: _filterList,
        currentMembers: _memberList,
      );
    }));

    if (filters != null && filters.length == 2) {
      _filterList = filters[0];
      _memberList = filters[1];
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: secondaryPageAppbar(
            context: context,
            title: "Deposit Receipts",
            action: () => Navigator.of(context).pop(),
            elevation: 1,
            leadingIcon: LineAwesomeIcons.arrow_left),
        backgroundColor: Theme.of(context).backgroundColor,
        body: RefreshIndicator(
            backgroundColor: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[800]
                : Colors.white,
            onRefresh: () => _fetchData(),
            child: Container(
                decoration: primaryGradient(context),
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: <Widget>[
                    Visibility(
                      visible: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            color: Theme.of(context)
                                                .bottomAppBarColor,
                                            width: 0.5),
                                        bottom: BorderSide(
                                            color: Theme.of(context)
                                                .bottomAppBarColor,
                                            width: 1.0))),
                                child: Material(
                                  color: Theme.of(context).backgroundColor,
                                  child: InkWell(
                                    onTap: () => showSortBottomSheet(),
                                    splashColor:
                                        Colors.blueGrey.withOpacity(0.2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(LineAwesomeIcons.sort,
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionHandleColor),
                                        subtitle1(
                                            text: "Sort",
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionHandleColor)
                                      ],
                                    ),
                                  ),
                                ) //loan.status == 2 ? null : repay),
                                ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color: Theme.of(context)
                                                .bottomAppBarColor,
                                            width: 0.5),
                                        bottom: BorderSide(
                                            color: Theme.of(context)
                                                .bottomAppBarColor,
                                            width: 1.0))),
                                child: Material(
                                  color: Theme.of(context).backgroundColor,
                                  child: InkWell(
                                    splashColor:
                                        Colors.blueGrey.withOpacity(0.2),
                                    onTap: () => showFilterOptions(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(LineAwesomeIcons.filter,
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionHandleColor),
                                        subtitle1(
                                            text: "Filter",
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionHandleColor)
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    _isLoading
                        ? showLinearProgressIndicator()
                        : SizedBox(
                            height: 0.0,
                          ),
                    Expanded(
                      child: _deposits.length > 0
                          ? NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (!_isLoading &&
                                    scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent &&
                                    _hasMoreData) {
                                  //TODO check if has more data before fetching again
                                  _fetchData();
                                }
                                return true;
                              },
                              child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    Deposit deposit = _deposits[index];
                                    // final indexValue = index;
                                    return DepositCard(
                                      // indexValue,
                                      deposit: deposit,
                                      details: () {},
                                      voidItem: () {},
                                    );
                                  },
                                  itemCount: _deposits.length),
                            )
                          : emptyList(
                              color: Colors.blue[400],
                              iconData: LineAwesomeIcons.angle_double_down,
                              text: "There are no deposits to display"),
                    )
                  ],
                ))));
  }
}

class DepositCard extends StatelessWidget {
  const DepositCard(
      {Key key, @required this.deposit, this.details, this.voidItem})
      : super(key: key);

  final Deposit deposit;
  final Function details, voidItem;

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
<<<<<<< HEAD
      child: Card(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderOnForeground: false,
        child: Container(
            decoration: cardDecoration(
                gradient: plainCardGradient(context), context: context),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
=======
      child: RepaintBoundary(
        key: _containerKey,
        child: Card(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          borderOnForeground: false,
          child: Container(
              decoration: cardDecoration(
                  gradient: plainCardGradient(context), context: context),
              child: Column(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              customTitle1(
                                text: deposit.type,
                                // fontSize: 16.0,
                                // ignore: deprecated_member_use
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.start,
                              ),
                              subtitle2(
                                text: deposit.name,
                                textAlign: TextAlign.start,
                                // ignore: deprecated_member_use
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
>>>>>>> develop
                          children: <Widget>[
                            customTitle(
                              text: deposit.type,
                              fontSize: 16.0,
                              // ignore: deprecated_member_use
                              color: Theme.of(context).textSelectionHandleColor,
                              textAlign: TextAlign.start,
                            ),
                            subtitle2(
                              text: deposit.name,
                              textAlign: TextAlign.start,
                              // ignore: deprecated_member_use
                              color: Theme.of(context).textSelectionHandleColor,
                            )
                          ],
                        ),
<<<<<<< HEAD
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          customTitle(
                            text: "${groupObject.groupCurrency} ",
                            fontSize: 18.0,
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor,
                            fontWeight: FontWeight.w400,
                          ),
                          heading2(
                            text: currencyFormat.format(deposit.amount),
                            // ignore: deprecated_member_use
                            color: Theme.of(context).textSelectionHandleColor,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            subtitle2(
                                text: "Paid By",
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.start),
                            subtitle1(
                                text: deposit.depositor,
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.start)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            subtitle2(
                                text: "Paid On",
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.end),
                            subtitle1(
                                text: deposit.date,
                                color:
                                    // ignore: deprecated_member_use
                                    Theme.of(context).textSelectionHandleColor,
                                textAlign: TextAlign.end)
                          ],
                        ),
                      ]),
                ),
                SizedBox(
                  height: 10,
                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Expanded(
//                      flex: 1,
//                      child: Container(
//                          decoration: BoxDecoration(
//                              border: Border(
//                                  top: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 1.0),
//                                  right: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 0.5))),
//                          child: plainButton(
//                              text: "SHOW DETAILS",
//                              size: 16.0,
//                              spacing: 2.0,
//                              color: Theme.of(context).primaryColor.withOpacity(0.5),
//                              // loan.status == 2 ? Theme.of(context).primaryColor.withOpacity(0.5) : Theme.of(context).primaryColor,
//                              action: details) //loan.status == 2 ? null : repay),
//                          ),
//                    ),
//                    Expanded(
//                      flex: 1,
//                      child: Container(
//                        decoration: BoxDecoration(
//                            border: Border(
//                                top: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 1.0),
//                                left: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 0.5))),
//                        child: plainButton(text: "VOID", size: 16.0, spacing: 2.0, color: Colors.blueGrey, action: voidItem),
//                      ),
//                    ),
//                  ],
//                )
              ],
            )),
=======
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              subtitle2(
                                  text: "Paid By",
                                  color:
                                      // ignore: deprecated_member_use
                                      Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                  textAlign: TextAlign.start),
                              customTitle1(
                                  text: deposit.depositor,
                                  color:
                                      // ignore: deprecated_member_use
                                      Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                  textAlign: TextAlign.start)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              subtitle2(
                                  text: "Paid On",
                                  color:
                                      // ignore: deprecated_member_use
                                      Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                  textAlign: TextAlign.end),
                              customTitle1(
                                  text: deposit.date,
                                  color:
                                      // ignore: deprecated_member_use
                                      Theme.of(context)
                                          // ignore: deprecated_member_use
                                          .textSelectionHandleColor,
                                  textAlign: TextAlign.end)
                            ],
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 1.0,
                    dashLength: 4.0,
                    dashColor: Colors.black45,
                    dashRadius: 0.0,
                    dashGapLength: 4.0,
                    dashGapColor: Colors.transparent,
                    dashGapRadius: 0.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(LineAwesomeIcons.trash
                                    // Icons.delete_forever,
                                    ),
                                iconSize: 20.0,
                                color: Colors.redAccent,
                                onPressed: () {
                                  // twoButtonAlertDialog(
                                  //     context: context,
                                  //     message:
                                  //         'Are you sure you want to delete this Transaction?',
                                  //     title: 'Confirm Action',

                                  //     action: () async {});

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor:
                                            Theme.of(context).backgroundColor,
                                        title: heading2(
                                          text: "Confirm Action",
                                          textAlign: TextAlign.start,
                                          // ignore: deprecated_member_use
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionHandleColor,
                                        ),
                                        content: customTitleWithWrap(
                                          text:
                                              "Are you sure you want to delete this Transaction?",
                                          textAlign: TextAlign.start,
                                          // ignore: deprecated_member_use
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionHandleColor,
                                          maxLines: null,
                                        ),
                                        actions: <Widget>[
                                          negativeActionDialogButton(
                                            text: "Cancel",
                                            // ignore: deprecated_member_use
                                            color: Theme.of(context)
                                                // ignore: deprecated_member_use
                                                .textSelectionHandleColor,
                                            action: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          // ignore: deprecated_member_use
                                          FlatButton(
                                            padding: EdgeInsets.fromLTRB(
                                                22.0, 0.0, 22.0, 0.0),
                                            child: customTitle(
                                              text: "Continue",
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();

                                              //   deposit.removeAt(index);
                                            },
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        4.0)),
                                            textColor: Colors.red,
                                            color: Colors.red.withOpacity(0.2),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              customTitle(
                                  text: 'Void',
                                  fontSize: 14.0,
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                  textAlign: TextAlign.end)
                            ],
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                DottedLine(
                                  direction: Axis.vertical,
                                  lineLength: 58.0,
                                  lineThickness: 1.0,
                                  dashLength: 4.0,
                                  dashColor: Colors.black45,
                                  dashRadius: 0.0,
                                  dashGapLength: 4.0,
                                  dashGapColor: Colors.transparent,
                                  dashGapRadius: 0.0,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              customTitleWithWrap(
                                  text: 'VIEW',
                                  fontSize: 14.0,
                                  color: Theme.of(context)
                                      // ignore: deprecated_member_use
                                      .textSelectionHandleColor,
                                  textAlign: TextAlign.end),
                              SizedBox(
                                width: 1.0,
                              ),
                              IconButton(
                                icon: Icon(
                                  LineAwesomeIcons.angle_right,
                                ),
                                iconSize: 12.0,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              new DetailReciept(
                                                  deposit.date,
                                                  deposit.name,
                                                  deposit.amount.toString(),
                                                  deposit.depositor,
                                                  deposit.narration,
                                                  deposit.type,
                                                  deposit.reconciliation)));
                                },
                              ),
                            ],
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //                Row(
                  //                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                  crossAxisAlignment: CrossAxisAlignment.center,
                  //                  children: <Widget>[
                  //                    Expanded(
                  //                      flex: 1,
                  //                      child: Container(
                  //                          decoration: BoxDecoration(
                  //                              border: Border(
                  //                                  top: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 1.0),
                  //                                  right: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 0.5))),
                  //                          child: plainButton(
                  //                              text: "SHOW DETAILS",
                  //                              size: 16.0,
                  //                              spacing: 2.0,
                  //                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                  //                              // loan.status == 2 ? Theme.of(context).primaryColor.withOpacity(0.5) : Theme.of(context).primaryColor,
                  //                              action: details) //loan.status == 2 ? null : repay),
                  //                          ),
                  //                    ),
                  //                    Expanded(
                  //                      flex: 1,
                  //                      child: Container(
                  //                        decoration: BoxDecoration(
                  //                            border: Border(
                  //                                top: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 1.0),
                  //                                left: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 0.5))),
                  //                        child: plainButton(text: "VOID", size: 16.0, spacing: 2.0, color: Colors.blueGrey, action: voidItem),
                  //                      ),
                  //                    ),
                  //                  ],
                  //                )
                ],
              )),
        ),
>>>>>>> develop
      ),
    );
  }
}