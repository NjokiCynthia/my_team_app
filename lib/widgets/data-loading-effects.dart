import 'package:carousel_slider/carousel_slider.dart';
import 'package:chamasoft/config.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/svg-icons.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/screens/chamasoft/meetings/meetings.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/widgets/annimationSlider.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
// import 'backgrounds.dart';

Widget dataLoadingEffect(
    {BuildContext context,
    double width,
    double height,
    double borderRadius = 16.0}) {
  return SizedBox(
    child: Shimmer.fromColors(
      baseColor: Theme.of(context).hintColor.withOpacity(0.1),
      highlightColor: Theme.of(context).hintColor.withOpacity(0.2),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          color: Theme.of(context).backgroundColor,
        ),
      ),
    ),
  );
}

Widget groupPlaceholder({BuildContext context}) {
  String currentLanguage =
      Provider.of<TranslationProvider>(context, listen: false).currentLanguage;
  return Column(
    children: <Widget>[
      showLinearProgressIndicator(),
      Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: cardDecoration(
              gradient: plainCardGradient(context), context: context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  customTitle(
                    text: "Contributions & Expenses",
                    color: Colors.blueGrey[400],
                    fontFamily: 'SegoeUI',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              Divider(
                color: Theme.of(context).hintColor.withOpacity(0.1),
                thickness: 2.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  customTitle(
                    text: "All Group Contributions",
                    textAlign: TextAlign.start,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                       
                        .textSelectionTheme
                        .selectionHandleColor,
                  ),
                  SizedBox(
                    height: 22,
                    child: cardAmountButton(
                      currency: 'KES',
                      amount: currencyFormat.format(0),
                      size: 16.0,
                      color: Theme.of(context)
                         
                          .textSelectionTheme
                          .selectionHandleColor,
                      action: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  customTitle(
                    text: "Total Fine Payments",
                    textAlign: TextAlign.start,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                       
                        .textSelectionTheme
                        .selectionHandleColor,
                  ),
                  SizedBox(
                    height: 22,
                    child: cardAmountButton(
                        currency: "KES",
                        amount: currencyFormat.format(0),
                        size: 16.0,
                        color: Theme.of(context)
                           
                            .textSelectionTheme
                            .selectionHandleColor,
                        action: () => {}),
                  ),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  customTitle(
                    text: "Group Expenses",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context)
                       
                        .textSelectionTheme
                        .selectionHandleColor,
                  ),
                  SizedBox(
                    height: 22,
                    child: cardAmountButton(
                      currency: "KES",
                      amount: currencyFormat.format(0),
                      size: 14.0,
                      color: Colors.red[400],
                      action: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 16.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              currentLanguage == 'English'
                  ? 'Account Balances'
                  : Provider.of<TranslationProvider>(context, listen: false)
                          .translate('Account Balances') ??
                      'Account Balances',
              // "Account Balances",
              style: TextStyle(
                color: Colors.blueGrey[400],
                fontFamily: 'SegoeUI',
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
                icon: Icon(
                  Feather.more_horizontal,
                  color: Colors.blueGrey,
                ),
                onPressed: () {})
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: Container(
          height: 180.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              SizedBox(
                width: 16.0,
              ),
              Container(
                width: 160.0,
                padding: EdgeInsets.all(16.0),
                decoration: cardDecoration(
                    gradient: csCardGradient(), context: context),
                child: accountBalance(
                  color: Colors.white,
                  cardIcon: Feather.globe,
                  cardAmount: currencyFormat.format(0),
                  currency: "KES",
                  accountName: "Total",
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Row(children: <Widget>[
                Container(
                  width: 160.0,
                  height: 165.0,
                  padding: EdgeInsets.all(16.0),
                  decoration: cardDecoration(
                      gradient: plainCardGradient(context), context: context),
                  child: accountBalance(
                    color: primaryColor,
                    cardIcon: Feather.credit_card,
                    cardAmount: currencyFormat.format(0),
                    currency: "KES",
                    accountName: "Cash at Bank",
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Container(
                  width: 160.0,
                  height: 165.0,
                  padding: EdgeInsets.all(16.0),
                  decoration: cardDecoration(
                      gradient: plainCardGradient(context), context: context),
                  child: accountBalance(
                    color: primaryColor,
                    cardIcon: Feather.credit_card,
                    cardAmount: currencyFormat.format(0),
                    currency: 'KES',
                    accountName: "Cash at Hand",
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: cardDecoration(
              gradient: plainCardGradient(context), context: context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Loan Balances",
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontFamily: 'SegoeUI',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Theme.of(context).hintColor.withOpacity(0.1),
                thickness: 2.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  customTitle(
                    text: "Loaned Out",
                    textAlign: TextAlign.start,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                       
                        .textSelectionTheme
                        .selectionHandleColor,
                  ),
                  SizedBox(
                    height: 22,
                    child: cardAmountButton(
                        currency: 'KES',
                        amount: currencyFormat.format(0),
                        size: 16.0,
                        color: Theme.of(context)
                           
                            .textSelectionTheme
                            .selectionHandleColor,
                        action: () {}),
                  ),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  customTitle(
                    text: "Total Repaid",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context)
                       
                        .textSelectionTheme
                        .selectionHandleColor,
                  ),
                  SizedBox(
                    height: 22,
                    child: cardAmountButton(
                        currency: 'KES',
                        amount: currencyFormat.format(0),
                        size: 14.0,
                        color: Theme.of(context)
                           
                            .textSelectionTheme
                            .selectionHandleColor,
                        action: () {}),
                  ),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  customTitle(
                    text: "Pending Loan Balance",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context)
                       
                        .textSelectionTheme
                        .selectionHandleColor,
                  ),
                  SizedBox(
                    height: 22,
                    child: cardAmountButton(
                        currency: 'KES',
                        amount: currencyFormat.format(0),
                        size: 14.0,
                        color: Theme.of(context)
                           
                            .textSelectionTheme
                            .selectionHandleColor,
                        action: () {}),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(
          16.0,
          16.0,
          16.0,
          16.0,
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: flatGradient(context),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Deposits Vs Withdrawals",
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontFamily: 'SegoeUI',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Feather.more_horizontal,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: 280,
                  margin: EdgeInsets.only(top: 24),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        customIcons['no-data'],
                        semanticsLabel: 'icon',
                        height: 120.0,
                      ),
                      customTitleWithWrap(
                          text: "Nothing to display!",
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0,
                          textAlign: TextAlign.center,
                          color: Colors.blueGrey[400]),
                      customTitleWithWrap(
                          text:
                              "Sorry, you don't have enough data to plot a chart.",
                          //fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                          textAlign: TextAlign.center,
                          color: Colors.blueGrey[400])
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ],
  );
}

Widget newHomePlaceHolder({BuildContext context}) {
  String _groupCurrency = 'KES';
  List cardList = [
    Contrubution(),
  ];
  int _currentIndex = 0;
  return Column(children: <Widget>[
    showLinearProgressIndicator(),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Account Balances",
                style: TextStyle(
                  color: Colors.blueGrey[400],
                  fontFamily: 'SegoeUI',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              plainButtonWithArrow(
                  text: "View All",
                  size: 16.0,
                  spacing: 2.0,
                  color: Colors.blue,
                  action: () {})
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 180.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              SizedBox(
                width: 16.0,
              ),
              Container(
                width: 160.0,
                padding: EdgeInsets.all(16.0),
                decoration: cardDecoration(
                    gradient: csCardGradient(), context: context),
                child: accountBalance(
                  color: Colors.white,
                  cardIcon: Feather.globe,
                  cardAmount: currencyFormat.format(0),
                  currency: _groupCurrency,
                  accountName: "Total",
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Row(children: <Widget>[
                Container(
                  width: 160.0,
                  height: 165.0,
                  padding: EdgeInsets.all(16.0),
                  decoration: cardDecoration(
                      gradient: plainCardGradient(context), context: context),
                  child: accountBalance(
                    color: primaryColor,
                    cardIcon: Feather.credit_card,
                    cardAmount: currencyFormat.format(0),
                    currency: _groupCurrency,
                    accountName: "Cash at Bank",
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Container(
                  width: 160.0,
                  height: 165.0,
                  padding: EdgeInsets.all(16.0),
                  decoration: cardDecoration(
                      gradient: plainCardGradient(context), context: context),
                  child: accountBalance(
                    color: primaryColor,
                    cardIcon: Feather.credit_card,
                    cardAmount: currencyFormat.format(0),
                    currency: _groupCurrency,
                    accountName: "Cash at Hand",
                  ),
                )
              ]),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Transactional Summary",
                style: TextStyle(
                  color: Colors.blueGrey[400],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              IconButton(
                  icon: Icon(
                    Feather.more_horizontal,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {})
            ],
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: cardDecoration(
              gradient: plainCardGradient(context),
              context: context,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 10),
                    autoPlayAnimationDuration: Duration(milliseconds: 1000),
                    autoPlayCurve: Curves.easeInCirc,
                    pauseAutoPlayOnTouch: true,
                    aspectRatio: 2.0,
                    initialPage: 0,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      // setState(() {
                      //   _currentIndex = index;
                      // });
                    },
                  ),
                  items: cardList.map((card) {
                    return Builder(builder: (BuildContext context) {
                      return Container(
                        // height:
                        //     MediaQuery.of(context).size.height *
                        //         0.70,
                        width: MediaQuery.of(context).size.width,
                        // child: Card(
                        child: card,
                        //),
                      );
                    });
                  }).toList(),
                ),

                SizedBox(
                  height: 5,
                ),
                customSlider(
                    context: context, count: cardList, index: _currentIndex)
                // animationSlider(),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Visibility(
          visible: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Make Payment",
                  style: TextStyle(
                    color: Colors.blueGrey[400],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Feather.more_horizontal,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {})
              ],
            ),
            /* child: Text(
              "Make Payments",
              style: TextStyle(
                color: Colors.blueGrey[400],
                fontFamily: 'SegoeUI',
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
              ),
            ), */
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          height: 80.0,
        ),
        Visibility(
          visible: false,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: paymentActionButton(
                      color: Colors.blueGrey[400],
                      textColor: Colors.blueGrey[400],
                      icon: FontAwesome.chevron_right,
                      isFlat: false,
                      text: "PAY NOW",
                      iconSize: 12.0,
                      action: () {},
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: paymentActionButton(
                        color: Colors.blueGrey[400],
                        textColor: Colors.white,
                        icon: FontAwesome.chevron_right,
                        isFlat: true,
                        text: "APPLY LOAN",
                        iconSize: 12.0,
                        action:
                            () /* => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              /* ApplyLoan */(){},
                                        ),
                                      ), */
                            {}),
                  ),
                ),
                // /*  Expanded(
                //   child: */
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     circleIconButton(
                //       icon: Icons.import_export,
                //       backgroundColor:
                //           primaryColor /* rimaryColor.withOpacity(.3) */,
                //       color: Colors.white,
                //       iconSize: 24.0,
                //       padding: 0.0,
                //       onPressed: () => _openPayNowTray(context),
                //     ),
                //     SizedBox(height: 10),
                //     customTitle1(
                //       text: 'Make Payment',
                //       color: Theme.of(context)
                //          
                //           .textSelectionHandleColor,
                //       textAlign: TextAlign.start,
                //       fontSize: 16,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ],
                // ),
                /*  ), */
                // SizedBox(width: 100),
                // Expanded(
                //   child: Column(
                //     children: [
                //       circleIconButton(
                //         icon: Icons.credit_card,
                //         backgroundColor:
                //             primaryColor /* rimaryColor.withOpacity(.3) */,
                //         color: Colors.white,
                //         iconSize: 24.0,
                //         padding: 0.0,
                //         onPressed:
                //             () /*  =>
                //               _showActions(context, incomeCategory) */
                //             {},
                //       ),
                //       SizedBox(height: 10),
                //       customTitle1(
                //         text: 'Apply Loan',
                //         color: Theme.of(context)
                //            
                //             .textSelectionHandleColor,
                //         textAlign: TextAlign.start,
                //         fontSize: 16,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Transactions",
                style: TextStyle(
                  color: Colors.blueGrey[400],
                  fontFamily: 'SegoeUI',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              plainButtonWithArrow(
                  text: "View All",
                  size: 16.0,
                  spacing: 2.0,
                  color: Colors.blue,
                  action: () {})
            ],
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 20.0),
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: flatGradient(context),
              child: Column(
                children: [
                  SvgPicture.asset(
                    customIcons['no-data'],
                    semanticsLabel: 'icon',
                    height: 120.0,
                  ),
                  customTitleWithWrap(
                      text: "Fetching Data!",
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                      textAlign: TextAlign.center,
                      color: Colors.blueGrey[400]),
                  customTitleWithWrap(
                      text: "Kindly Wait, Fetching Data",
                      //fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                      textAlign: TextAlign.center,
                      color: Colors.blueGrey[400])
                ],
              )),
        ),
      ],
    )
  ]);
}

class Contrubution extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;
    return Container(
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          decoration: flatGradient(context),
          child: Column(
            children: [
              SvgPicture.asset(
                customIcons['no-data'],
                semanticsLabel: 'icon',
                height: 120.0,
              ),
              customTitleWithWrap(
                  text: "Fetching Data!",
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                  textAlign: TextAlign.center,
                  color: Colors.blueGrey[400]),
              customTitleWithWrap(
                  text: "Kindy Wait, Fetching Data",
                  //fontWeight: FontWeight.w500,
                  fontSize: 12.0,
                  textAlign: TextAlign.center,
                  color: Colors.blueGrey[400])
            ],
          )),
    );

    //  Container(
    //   color: Theme.of(context).backgroundColor,
    //   child: Column(
    //     children: [
    //       Row(
    //         children: [
    //           chart.PieChart(
    //             dataMap: dataMap,
    //             animationDuration: Duration(milliseconds: 800),
    //             chartLegendSpacing: 32,
    //             chartRadius: MediaQuery.of(context).size.width / 3.2,
    //             initialAngleInDegree: 0,
    //             ringStrokeWidth: 32,
    //             legendOptions: chart.LegendOptions(
    //               showLegendsInRow: false,
    //               legendPosition: chart.LegendPosition.right,
    //               showLegends: false,
    //               legendTextStyle: TextStyle(
    //                   fontWeight: FontWeight.w500,
    //                  
    //                   color: Theme.of(context).textSelectionHandleColor),
    //             ),
    //             chartValuesOptions: chart.ChartValuesOptions(
    //               showChartValueBackground: false,
    //               showChartValues: true,
    //               showChartValuesInPercentage: true,
    //               showChartValuesOutside: false,
    //               decimalPlaces: 1,
    //             ),
    //           ),
    //           Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               Text(
    //                 "My Total Contribution",
    //                 style: TextStyle(
    //                   color: Colors.blueGrey[400],
    //                   fontFamily: 'SegoeUI',
    //                   fontSize: 14.0,
    //                   fontWeight: FontWeight.w800,
    //                 ),
    //               ),
    //               customTitle1(
    //                 text: _currentGroup.groupCurrency + " " + " 0",
    //                 color: Theme.of(context)
    //                    
    //                     .textSelectionHandleColor,
    //                 textAlign: TextAlign.start,
    //                 fontSize: 14,
    //                 fontWeight: FontWeight.w400,
    //               ),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               Text(
    //                 "Group Total Contribution",
    //                 style: TextStyle(
    //                   color: Colors.blueGrey[400],
    //                   fontFamily: 'SegoeUI',
    //                   fontSize: 14.0,
    //                   fontWeight: FontWeight.w800,
    //                 ),
    //               ),
    //               customTitle1(
    //                 color: Theme.of(context)
    //                    
    //                     .textSelectionHandleColor,
    //                 text: _currentGroup.groupCurrency + " " + "0 ",
    //                 textAlign: TextAlign.start,
    //                 fontSize: 14,
    //                 fontWeight: FontWeight.w400,
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //       // DottedLine(
    //       //   direction: Axis.horizontal,
    //       //   lineLength: double.infinity,
    //       //   lineThickness: 0.5,
    //       //   dashLength: 2.0,
    //       //   dashColor: Colors.black45,
    //       //   dashRadius: 0.0,
    //       //   dashGapLength: 2.0,
    //       //   dashGapColor: Colors.transparent,
    //       //   dashGapRadius: 0.0,
    //       // ),
    //       // Row(
    //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       //   children: [
    //       //     // Column(
    //       //     //   crossAxisAlignment: CrossAxisAlignment.start,
    //       //     //   children: [
    //       //     //     Text(
    //       //     //       "Next Conribution",
    //       //     //       style: TextStyle(
    //       //     //         color: Colors.blueGrey[400],
    //       //     //         fontFamily: 'SegoeUI',
    //       //     //         fontSize: 14.0,
    //       //     //         fontWeight: FontWeight.w800,
    //       //     //       ),
    //       //     //     ),
    //       //     //     Row(
    //       //     //       children: [
    //       //     //         customTitle1(
    //       //     //           text: "KES 100,000",
    //       //     //           textAlign: TextAlign.start,
    //       //     //           fontSize: 14,
    //       //     //           fontWeight: FontWeight.w400,
    //       //     //           color: Theme.of(context)
    //       //     //              
    //       //     //               .textSelectionHandleColor,
    //       //     //         ),
    //       //     //         SizedBox(
    //       //     //           width: 20,
    //       //     //         ),
    //       //     //         customTitle1(
    //       //     //           text: contributionsSummary.dueDate,
    //       //     //           textAlign: TextAlign.start,
    //       //     //           fontSize: 14,
    //       //     //           fontWeight: FontWeight.w400,
    //       //     //           color: Theme.of(context)
    //       //     //              
    //       //     //               .textSelectionHandleColor,
    //       //     //         ),
    //       //     //       ],
    //       //     //     )
    //       //     //   ],
    //       //     // ),
    //       //     buttonWithArrow(
    //       //         text: "Pay Now",
    //       //         size: 14.0,
    //       //         spacing: 2.0,
    //       //         color: Colors.white,
    //       //         action: () => _openPayNowTray(context))
    //       //   ],
    //       // ),
    //     ],
    //   ),
    // );
  }
}

Widget homePlaceholder({BuildContext context}) {
  Group _currentGroup;
  bool _onlineBankingEnabled = true;
  String _groupCurrency = 'KES';
  _currentGroup = Provider.of<Groups>(context, listen: false).getCurrentGroup();
  String currentLanguage =
      Provider.of<TranslationProvider>(context, listen: false).currentLanguage;
  return Column(
    children: <Widget>[
      showLinearProgressIndicator(),
      Visibility(
        visible: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16.0,
            16.0,
            16.0,
            16.0,
          ),
          child: Container(
            width: double.infinity,
            decoration: cardDecoration(
              gradient: plainCardGradient(context),
              context: context,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Stack(
                children: <Widget>[
                  Image(
                    image: AssetImage(
                      'assets/meeting-minutes.jpg',
                    ),
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.3),
                      padding: EdgeInsets.only(
                        right: 16.0,
                        top: 6.0,
                        bottom: 6.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${Config.appName} Meetings",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'SegoeUI',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              subtitle2(
                                color: Colors.white.withOpacity(0.9),
                                text: "Manage group meetings, easily.",
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => Meetings(),
                              ),
                            ),
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'SegoeUI',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "Don't show this again",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontFamily: 'SegoeUI',
                                fontWeight: FontWeight.w300,
                                fontSize: 11.0,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(
          16.0,
          16.0,
          16.0,
          0.0,
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: cardDecoration(
            gradient: plainCardGradient(context),
            context: context,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  customTitle(
                    text: _currentGroup.disableArrears
                        ? "Total Deposits and Loan Balances"
                        : "Total Balances",
                    color: Colors.blueGrey[400],
                    fontFamily: 'SegoeUI',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              Divider(
                color: Theme.of(context).hintColor.withOpacity(0.1),
                thickness: 2.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  customTitle(
                    text: "Your Contribution Balance",
                    textAlign: TextAlign.start,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context)
                       
                        .textSelectionTheme
                        .selectionHandleColor,
                  ),
                  SizedBox(
                    height: 22,
                    child: cardAmountButton(
                      currency: _groupCurrency,
                      amount: _currentGroup.disableArrears
                          ? currencyFormat.format(0)
                          : currencyFormat.format(0),
                      size: 16.0,
                      color: (0) > 0
                          ? Colors.red[400]
                          : Theme.of(context)
                             
                              .textSelectionTheme
                              .selectionHandleColor,
                      action: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  customTitle(
                    text: "Fines",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context)
                       
                        .textSelectionTheme
                        .selectionHandleColor,
                  ),
                  SizedBox(
                    height: 22,
                    child: cardAmountButton(
                        currency: _groupCurrency,
                        amount: _currentGroup.disableArrears
                            ? currencyFormat.format(0)
                            : currencyFormat.format(0),
                        size: 14.0,
                        color: (0) > 0
                            ? Colors.red[400]
                            : Theme.of(context)
                               
                                .textSelectionTheme
                                .selectionHandleColor,
                        action: () {}),
                  ),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  customTitle(
                    text: "Loans",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context)
                       
                        .textSelectionTheme
                        .selectionHandleColor,
                  ),
                  SizedBox(
                    height: 22,
                    child: cardAmountButton(
                        currency: _groupCurrency,
                        amount: currencyFormat.format(0),
                        size: 14.0,
                        color: (0) > 0
                            ? Colors.red[400]
                            : Theme.of(context)
                               
                                .textSelectionTheme
                                .selectionHandleColor,
                        action: () {}),
                  ),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  customTitle(
                    text: "Pending Installment Balance",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context)
                       
                        .textSelectionTheme
                        .selectionHandleColor,
                  ),
                  SizedBox(
                    height: 22,
                    child: cardAmountButton(
                        currency: _groupCurrency,
                        amount: currencyFormat.format(0),
                        size: 14.0,
                        color: (0) > 0
                            ? Colors.red[400]
                            : Theme.of(context)
                               
                                .textSelectionTheme
                                .selectionHandleColor,
                        action: () {}),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // Padding(
      //   padding: EdgeInsets.fromLTRB(
      //     20.0,
      //     10.0,
      //     16.0,
      //     0.0,
      //   ),
      //   child: Row(
      //     mainAxisAlignment:
      //         MainAxisAlignment.spaceBetween,
      //     children: <Widget>[
      //       Text(
      //         "E-Wallet",
      //         style: TextStyle(
      //           color: Colors.blueGrey[400],
      //           fontFamily: 'SegoeUI',
      //           fontSize: 16.0,
      //           fontWeight: FontWeight.w800,
      //         ),
      //       ),
      //       IconButton(
      //         icon: Icon(
      //           Feather.more_horizontal,
      //           color: Colors.blueGrey,
      //         ),
      //         onPressed: () {},
      //       ),
      //     ],
      //   ),
      // ),
      // Padding(
      //   padding: EdgeInsets.fromLTRB(
      //     16.0,
      //     20.0,
      //     16.0,
      //     0.0,
      //   ),
      //   child: Container(
      //     padding: EdgeInsets.all(16.0),
      //     decoration: cardDecoration(
      //       gradient: plainCardGradient(context),
      //       context: context,
      //     ),
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: <Widget>[
      //         Row(
      //           mainAxisAlignment:
      //               MainAxisAlignment.spaceBetween,
      //           children: <Widget>[
      //             Column(
      //               crossAxisAlignment:
      //                   CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   "Wallet Balance",
      //                   style: TextStyle(
      //                     color: Colors.blueGrey[400],
      //                     fontFamily: 'SegoeUI',
      //                     fontSize: 16.0,
      //                     fontWeight: FontWeight.w600,
      //                   ),
      //                   textAlign: TextAlign.start,
      //                 ),
      //                 Row(
      //                   children: [
      //                     Text(
      //                       "KES",
      //                       style: TextStyle(
      //                         color: Colors.blueGrey[400],
      //                         fontFamily: 'SegoeUI',
      //                         fontSize: 32.0,
      //                         fontWeight: FontWeight.w300,
      //                       ),
      //                       textAlign: TextAlign.start,
      //                     ),
      //                     SizedBox(width: 6.0),
      //                     Text(
      //                       "12,390",
      //                       style: TextStyle(
      //                         color: Colors.blueGrey[400],
      //                         fontFamily: 'SegoeUI',
      //                         fontSize: 32.0,
      //                         fontWeight: FontWeight.w600,
      //                       ),
      //                       textAlign: TextAlign.start,
      //                     ),
      //                   ],
      //                 ),
      //                 SizedBox(height: 12.0),
      //                 SizedBox(
      //                   height: 32.0,
      //                   child: LineChart(
      //                     eWalletTrend(),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             Column(
      //               crossAxisAlignment:
      //                   CrossAxisAlignment.end,
      //               children: [
      //                 Text(
      //                   "Deposits",
      //                   style: TextStyle(
      //                     color: Colors.blueGrey[400],
      //                     fontFamily: 'SegoeUI',
      //                     fontSize: 12.0,
      //                     fontWeight: FontWeight.w300,
      //                   ),
      //                   textAlign: TextAlign.start,
      //                 ),
      //                 Row(
      //                   children: [
      //                     Icon(
      //                       Icons.arrow_drop_down_sharp,
      //                       color: Colors.red,
      //                     ),
      //                     Text(
      //                       "0.92%",
      //                       style: TextStyle(
      //                         color: Colors.blueGrey[400],
      //                         fontFamily: 'SegoeUI',
      //                         fontSize: 12.0,
      //                         fontWeight: FontWeight.w600,
      //                       ),
      //                       textAlign: TextAlign.start,
      //                     ),
      //                   ],
      //                 ),
      //                 SizedBox(height: 12.0),
      //                 Text(
      //                   "Withdrawals",
      //                   style: TextStyle(
      //                     color: Colors.blueGrey[400],
      //                     fontFamily: 'SegoeUI',
      //                     fontSize: 12.0,
      //                     fontWeight: FontWeight.w300,
      //                   ),
      //                   textAlign: TextAlign.start,
      //                 ),
      //                 Row(
      //                   children: [
      //                     Icon(
      //                       Icons.arrow_drop_up_sharp,
      //                       color: Colors.green,
      //                     ),
      //                     Text(
      //                       "1.2%",
      //                       style: TextStyle(
      //                         color: Colors.blueGrey[400],
      //                         fontFamily: 'SegoeUI',
      //                         fontSize: 12.0,
      //                         fontWeight: FontWeight.w600,
      //                       ),
      //                       textAlign: TextAlign.start,
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      Padding(
        padding: EdgeInsets.fromLTRB(
          20.0,
          20.0,
          16.0,
          0.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              currentLanguage == 'English'
                  ? "Contribution Summary"
                  : Provider.of<TranslationProvider>(context, listen: false)
                          .translate("Contribution Summary") ??
                      "Contribution Summary",
              style: TextStyle(
                color: Colors.blueGrey[400],
                fontFamily: 'SegoeUI',
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            IconButton(
              icon: Icon(
                Feather.more_horizontal,
                color: Colors.blueGrey,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 20.0),
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            decoration: flatGradient(context),
            child: Column(
              children: [
                SvgPicture.asset(
                  customIcons['no-data'],
                  semanticsLabel: 'icon',
                  height: 120.0,
                ),
                customTitleWithWrap(
                    text: "Nothing to display!",
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                    textAlign: TextAlign.center,
                    color: Colors.blueGrey[400]),
                customTitleWithWrap(
                    text: "Sorry, you haven't made any contributions",
                    //fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                    textAlign: TextAlign.center,
                    color: Colors.blueGrey[400])
              ],
            )),
      ),
      if (_onlineBankingEnabled)
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
          child: Container(
            // ignore: todo
            // width: 260, //TODO: Remove this when you uncomment the 'APPLY LOAD' button below
            padding: EdgeInsets.symmetric(vertical: 10.0),
            color: Theme.of(context).cardColor.withOpacity(0.1),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: paymentActionButton(
                      color: primaryColor,
                      textColor: primaryColor,
                      icon: FontAwesome.chevron_right,
                      isFlat: false,
                      text: "PAY NOW",
                      iconSize: 12.0,
                      action: () {},
                    ),
                  ),
                ),
                // Expanded(
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(
                //       horizontal: 16.0,
                //     ),
                //     child: paymentActionButton(
                //       color: primaryColor,
                //       textColor: Colors.white,
                //       icon: FontAwesome.chevron_right,
                //       isFlat: true,
                //       text: "APPLY LOAN",
                //       iconSize: 12.0,
                //       action: () => Navigator.of(context).push(
                //         MaterialPageRoute(
                //           builder: (BuildContext context) =>
                //               ApplyLoan(),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      Padding(
        padding: EdgeInsets.fromLTRB(
          20.0,
          0.0,
          16.0,
          0.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Recent Transactions",
              style: TextStyle(
                color: Colors.blueGrey[400],
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            IconButton(
                icon: Icon(
                  Feather.more_horizontal,
                  color: Colors.blueGrey,
                ),
                onPressed: () {})
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 20.0),
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            decoration: flatGradient(context),
            child: Column(
              children: [
                SvgPicture.asset(
                  customIcons['no-data'],
                  semanticsLabel: 'icon',
                  height: 120.0,
                ),
                customTitleWithWrap(
                    text: "Nothing to display!",
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                    textAlign: TextAlign.center,
                    color: Colors.blueGrey[400]),
                customTitleWithWrap(
                    text: "Sorry, you haven't made any transactions",
                    //fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                    textAlign: TextAlign.center,
                    color: Colors.blueGrey[400])
              ],
            )),
      ),
    ],
  );
}

Widget chamasoftHomeLoadingData({BuildContext context}) {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Container(
          padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  dataLoadingEffect(
                    context: context,
                    width: 200,
                    height: 20,
                    borderRadius: 16.0,
                  )
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Divider(
                color: Theme.of(context).hintColor.withOpacity(0),
                thickness: 2.0,
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(
                    context: context,
                    width: 120,
                    height: 20,
                    borderRadius: 16.0,
                  ),
                  dataLoadingEffect(
                    context: context,
                    width: 80,
                    height: 20,
                    borderRadius: 16.0,
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(
                    context: context,
                    width: 80,
                    height: 16,
                    borderRadius: 16.0,
                  ),
                  dataLoadingEffect(
                    context: context,
                    width: 100,
                    height: 16,
                    borderRadius: 16.0,
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(
                    context: context,
                    width: 50,
                    height: 16,
                    borderRadius: 16.0,
                  ),
                  dataLoadingEffect(
                    context: context,
                    width: 80,
                    height: 16,
                    borderRadius: 16.0,
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(
                      context: context,
                      width: 140,
                      height: 16,
                      borderRadius: 16.0),
                  dataLoadingEffect(
                      context: context,
                      width: 100,
                      height: 16,
                      borderRadius: 16.0),
                ],
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(20.0, 6.0, 16.0, 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dataLoadingEffect(
                    context: context,
                    width: 160,
                    height: 20,
                    borderRadius: 16.0)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dataLoadingEffect(
                    context: context, width: 60, height: 20, borderRadius: 16.0)
              ],
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: Container(
          height: 180.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              SizedBox(
                width: 16.0,
              ),
              dataLoadingEffect(
                context: context,
                width: 160,
                height: 160,
                borderRadius: 16.0,
              ),
              SizedBox(
                width: 26.0,
              ),
              dataLoadingEffect(
                context: context,
                width: 160,
                height: 160,
                borderRadius: 16.0,
              ),
              SizedBox(
                width: 26.0,
              ),
              dataLoadingEffect(
                context: context,
                width: 160,
                height: 160,
                borderRadius: 16.0,
              ),
              SizedBox(
                width: 26.0,
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          color: Theme.of(context).cardColor.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      dataLoadingEffect(
                          context: context,
                          width: 190,
                          height: 42,
                          borderRadius: 10.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dataLoadingEffect(
                  context: context,
                  width: 160,
                  height: 20,
                  borderRadius: 16.0,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dataLoadingEffect(
                  context: context,
                  width: 60,
                  height: 20,
                  borderRadius: 16.0,
                ),
              ],
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 10.0),
        child: Container(
          height: 180.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              SizedBox(
                width: 16.0,
              ),
              dataLoadingEffect(
                context: context,
                width: 160,
                height: 160,
                borderRadius: 16.0,
              ),
              SizedBox(
                width: 26.0,
              ),
              dataLoadingEffect(
                context: context,
                width: 160,
                height: 160,
                borderRadius: 16.0,
              ),
              SizedBox(
                width: 26.0,
              ),
              dataLoadingEffect(
                context: context,
                width: 160,
                height: 160,
                borderRadius: 16.0,
              ),
              SizedBox(
                width: 26.0,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget chamasoftGroupLoadingData({BuildContext context}) {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Container(
          padding: EdgeInsets.only(
            top: 16.0,
            bottom: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  dataLoadingEffect(
                      context: context,
                      width: 200,
                      height: 20,
                      borderRadius: 16.0)
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Divider(
                color: Theme.of(context).hintColor.withOpacity(0.1),
                thickness: 2.0,
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(
                      context: context,
                      width: 120,
                      height: 20,
                      borderRadius: 16.0),
                  dataLoadingEffect(
                      context: context,
                      width: 80,
                      height: 20,
                      borderRadius: 16.0),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(
                      context: context,
                      width: 80,
                      height: 16,
                      borderRadius: 16.0),
                  dataLoadingEffect(
                      context: context,
                      width: 100,
                      height: 16,
                      borderRadius: 16.0),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(
                      context: context,
                      width: 50,
                      height: 16,
                      borderRadius: 16.0),
                  dataLoadingEffect(
                      context: context,
                      width: 80,
                      height: 16,
                      borderRadius: 16.0),
                ],
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(20.0, 6.0, 16.0, 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dataLoadingEffect(
                  context: context,
                  width: 160,
                  height: 20,
                  borderRadius: 16.0,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dataLoadingEffect(
                    context: context, width: 60, height: 20, borderRadius: 16.0)
              ],
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 10.0),
        child: Container(
          height: 180.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              SizedBox(
                width: 16.0,
              ),
              dataLoadingEffect(
                context: context,
                width: 160,
                height: 160,
                borderRadius: 16.0,
              ),
              SizedBox(
                width: 26.0,
              ),
              dataLoadingEffect(
                context: context,
                width: 160,
                height: 160,
                borderRadius: 16.0,
              ),
              SizedBox(
                width: 26.0,
              ),
              dataLoadingEffect(
                context: context,
                width: 160,
                height: 160,
                borderRadius: 16.0,
              ),
              SizedBox(
                width: 26.0,
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Container(
          padding: EdgeInsets.only(
            top: 16.0,
            bottom: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  dataLoadingEffect(
                    context: context,
                    width: 200,
                    height: 20,
                    borderRadius: 16.0,
                  )
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Divider(
                color: Theme.of(context).hintColor.withOpacity(0.1),
                thickness: 2.0,
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(
                    context: context,
                    width: 120,
                    height: 20,
                    borderRadius: 16.0,
                  ),
                  dataLoadingEffect(
                    context: context,
                    width: 80,
                    height: 20,
                    borderRadius: 16.0,
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(
                    context: context,
                    width: 80,
                    height: 16,
                    borderRadius: 16.0,
                  ),
                  dataLoadingEffect(
                    context: context,
                    width: 100,
                    height: 16,
                    borderRadius: 16.0,
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(
                    context: context,
                    width: 150,
                    height: 16,
                    borderRadius: 16.0,
                  ),
                  dataLoadingEffect(
                    context: context,
                    width: 80,
                    height: 16,
                    borderRadius: 16.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

LinearProgressIndicator showLinearProgressIndicator() {
  return LinearProgressIndicator(
    backgroundColor: Colors.cyanAccent,
    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
  );
}
