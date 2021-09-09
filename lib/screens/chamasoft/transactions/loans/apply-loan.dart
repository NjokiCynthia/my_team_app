import 'package:chamasoft/screens/chamasoft/transactions/loans/chamasoft-loan-type.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/loan-amortization.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../../dashboard.dart';

class ApplyLoan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ApplyLoanState();
  }
}

class ApplyLoanState extends State<ApplyLoan> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

  bool isShow = true;
  bool isHiden = false;

  double amountInputValue;

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

  static final List<String> _dropdownItems = <String>[
    'Emergency Loan',
    'Education Loan'
  ];
  final formKey = new GlobalKey<FormState>();
  String _dropdownValue;
  String _errorText;

  Widget buildDropDown() {
    return FormField(
      builder: (FormFieldState state) {
        return DropdownButtonHideUnderline(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new InputDecorator(
                decoration: InputDecoration(
                    labelStyle: inputTextStyle(),
                    hintStyle: inputTextStyle(),
                    errorStyle: inputTextStyle(),
                    filled: false,
                    hintText: 'Select Loan Type',
                    labelText: _dropdownValue == null
                        ? 'Select Loan Type'
                        : 'Select Loan Type',
                    errorText: _errorText,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).hintColor, width: 1.0))),
                isEmpty: _dropdownValue == null,
                child: new Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: (themeChangeProvider.darkTheme)
                        ? Colors.blueGrey[800]
                        : Colors.white,
                  ),
                  child: new DropdownButton<String>(
                    value: _dropdownValue,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        _dropdownValue = newValue;
                      });
                    },
                    items: _dropdownItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: inputTextStyle(),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ChamasoftDashboard(),
          ),
        ),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Apply Loan",
      ),
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            color: Theme.of(context).backgroundColor,
            padding: EdgeInsets.all(0.0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            //  color: Theme.of(context).backgroundColor,

//Control Switches Wigets
            child: Column(
              children: <Widget>[
                // loanSwitches(isShow),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: FlutterToggleTab(
                        width: 55.0,
                        height: 30.0,
                        borderRadius: 10.0,
                        labels: ['From Group', 'From ChamaSoft'],
                        initialIndex: 0,
                        selectedLabelIndex: (index) {
                          setState(() {
                            if (index == 0) {
                              isShow = true;
                              isHiden = false;
                            }
                            if (index == 1) {
                              isShow = false;
                              isHiden = true;
                            }
                          });
                        },
                        selectedBackgroundColors: [Colors.grey],
                        unSelectedBackgroundColors: [Colors.white70],
                        selectedTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600),
                        unSelectedTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
//Coteiner for Group Loans
                Container(
                  child: Visibility(
                    visible: isShow,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.0),
                          //height: MediaQuery.of(context).size.height,
                          color: Theme.of(context).backgroundColor,
                          child: Column(
                            children: <Widget>[
                              toolTip(
                                  context: context,
                                  title: "Note that...",
                                  message:
                                      "Loan application process is totally depended on your group's constitution and your group\'s management."),
                              buildDropDown(),
                              amountTextInputField(
                                  context: context,
                                  labelText: "Amount applying for",
                                  onChanged: (value) {
                                    setState(() {
                                      amountInputValue = double.parse(value);
                                    });
                                  }),
                              SizedBox(
                                height: 24,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 30.0, right: 30.0),
                                child: textWithExternalLinks(
                                    color: Colors.blueGrey,
                                    size: 12.0,
                                    textData: {
                                      'By applying for this loan you agree to the ':
                                          {},
                                      'terms and conditions': {
                                        "url": () => Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        LoanAmortization(),
                                              ),
                                            ),
                                        "color": primaryColor,
                                        "weight": FontWeight.w500
                                      },
                                    }),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              defaultButton(
                                  context: context,
                                  text: "Apply Now",
                                  onPressed: () {})
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

//Conteiner Widget for Chamasoft Loans

                Container(
                  child: Visibility(
                    visible: isHiden,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.0),
                          //height: MediaQuery.of(context).size.height,
                          color: Theme.of(context).backgroundColor,
                          child: Column(
                            children: <Widget>[
                              toolTip(
                                  context: context,
                                  title: "Note that...",
                                  message:
                                      "Apply quick loan from Chamasoft guaranteed by your savings and fellow group members."),
                              SizedBox(
                                height: 12.0,
                              ),
                              Card(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                borderOnForeground: false,
                                child: Container(
                                  decoration: cardDecoration(
                                      gradient: plainCardGradient(context),
                                      context: context),
                                  child: ListTile(
                                    title: Text("Education Loan"),
                                    subtitle: Text("Limited to KES 8,000 PM"),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChamaSoftLoanDetail()),
                                        );
                                      },
                                      icon:
                                          Icon(Icons.arrow_forward_ios_rounded),
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Card(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                borderOnForeground: false,
                                child: Container(
                                  decoration: cardDecoration(
                                      gradient: plainCardGradient(context),
                                      context: context),
                                  child: ListTile(
                                    title: Text("Normal Loan"),
                                    subtitle: Text(
                                        "Available to a Makimum of 3 times"),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChamaSoftLoanDetail()),
                                        );
                                      },
                                      icon:
                                          Icon(Icons.arrow_forward_ios_rounded),
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Card(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                borderOnForeground: false,
                                child: Container(
                                  decoration: cardDecoration(
                                      gradient: plainCardGradient(context),
                                      context: context),
                                  child: ListTile(
                                    title: Text("Business Loan"),
                                    subtitle: Text(
                                        "payable with interest, Limit to KES 1,000,000"),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChamaSoftLoanDetail()),
                                        );
                                      },
                                      icon:
                                          Icon(Icons.arrow_forward_ios_rounded),
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Card(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                borderOnForeground: false,
                                child: Container(
                                  decoration: cardDecoration(
                                      gradient: plainCardGradient(context),
                                      context: context),
                                  child: ListTile(
                                    title: Text("Payday Loans"),
                                    subtitle:
                                        Text("Due in 24 Hrs, Limit KES 25,000"),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChamaSoftLoanDetail()),
                                        );
                                      },
                                      icon:
                                          Icon(Icons.arrow_forward_ios_rounded),
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Card(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                borderOnForeground: false,
                                child: Container(
                                  decoration: cardDecoration(
                                      gradient: plainCardGradient(context),
                                      context: context),
                                  child: ListTile(
                                    title: Text("Credit Card Cash Advances"),
                                    subtitle: Text(
                                        "ShortTerm Loan for upto a month, for employees only"),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChamaSoftLoanDetail()),
                                        );
                                      },
                                      icon:
                                          Icon(Icons.arrow_forward_ios_rounded),
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
