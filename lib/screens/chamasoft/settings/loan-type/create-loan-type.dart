import 'package:chamasoft/screens/chamasoft/settings/loan-type/loan-fees-and-guarantors.dart';
import 'package:chamasoft/screens/chamasoft/settings/loan-type/loan-type-fines.dart';
import 'package:chamasoft/screens/chamasoft/settings/loan-type/loan-type-settings.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class CreateLoanType extends StatefulWidget {
  final bool isEditMode;
  final dynamic loanDetails;

  CreateLoanType({this.isEditMode, this.loanDetails});

  @override
  _CreateLoanTypeState createState() => _CreateLoanTypeState();
}

class _CreateLoanTypeState extends State<CreateLoanType>
    with SingleTickerProviderStateMixin {
  double _appBarElevation = 0;
  PageController _pageController;
  int currentPage = 0;
  dynamic responseData;
  int _formEdited = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_formEdited);
        return new Future(() => true);
      },
      child: Scaffold(
        appBar: secondaryPageTabbedAppbar(
          context: context,
          title:
              widget.isEditMode == null ? "Create Loan Type" : "Edit Loan Type",
          action: () => Navigator.of(context).pop(_formEdited),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 50,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            child: Divider(
                              thickness: 5.0,
                              indent: 10,
                              endIndent: 10,
                              color: currentPage == 0
                                  ? primaryColor
                                  : Color(0xFFAEAEAE),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            child: Divider(
                              thickness: 5.0,
                              indent: 10,
                              endIndent: 10,
                              color: currentPage == 1
                                  ? primaryColor
                                  : Color(0xFFAEAEAE),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            child: Divider(
                              thickness: 5.0,
                              indent: 10,
                              endIndent: 10,
                              color: currentPage == 2
                                  ? primaryColor
                                  : Color(0xFFAEAEAE),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: [
                        new LoanTypeSettings(
                          isEditMode: widget.isEditMode == null ? false : true,
                          loanDetails: widget.loanDetails,
                          onButtonPressed: (response) {
                            if (_pageController.hasClients) {
                              _pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }
                            setState(() {
                              currentPage = 1;
                              _formEdited = 1;
                              responseData = response;
                            });
                          },
                        ),
                        new LoanTypeFines(
                            responseData: responseData,
                            isEditMode:
                                widget.isEditMode == null ? false : true,
                            loanDetails: widget.loanDetails,
                            onButtonPressed: (response) {
                              if (_pageController.hasClients) {
                                _pageController.animateToPage(
                                  2,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }

                              setState(() {
                                responseData = response;
                                currentPage = 2;
                                _formEdited = 1;
                              });
                            }),
                        new LoanFeesAndGuarantors(
                            responseData: responseData,
                            isEditMode:
                                widget.isEditMode == null ? false : true,
                            loanDetails: widget.loanDetails,
                            onButtonPressed: (response) {
                              Navigator.of(context).pop(_formEdited);
                            })
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
