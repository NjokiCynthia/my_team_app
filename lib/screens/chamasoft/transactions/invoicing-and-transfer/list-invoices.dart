import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/create-invoice.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ListInvoices extends StatefulWidget {
  @override
  _ListInvoicesState createState() => _ListInvoicesState();
}

class _ListInvoicesState extends State<ListInvoices> {
  bool _isLoading = false;
  Future<void> fetchInvoices(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Groups>(context, listen: false).fetchInvoices();
      // Navigator.pop(context);
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => ListFineTypes()));
    } on CustomException catch (error) {
      print(error.message);
      final snackBar = SnackBar(
        content: Text('Network Error occurred: could not fetch invoices'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () async {
            fetchInvoices(context);
          },
        ),
      );
      // Navigator.pop(context);
      // ignore: deprecated_member_use
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      _isLoading = false;
    });
  }

  BuildContext bodyContext;

  void _voidMemberInvoice(BuildContext context, String id) async {
    if (context == null) {
      print("Error: Provided context is null.");
      return;
    }

    showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Use the provided context instead of bodyContext
      await Provider.of<Groups>(context, listen: false)
          .voidMemberInvoice(id, context);
      Navigator.of(context).pop(); // Dismiss dialog
      StatusHandler().showSuccessSnackBar(
        context,
        "Good news: Invoice successfully voided",
      );
      await fetchInvoices(context);
    } on CustomException catch (error) {
      Navigator.of(context).pop(); // Dismiss dialog on error
      StatusHandler().handleStatus(
        context: context,
        error: error,
        callback: () {
          _voidMemberInvoice(context, id); // Retry the operation
        },
      );
    } finally {
      // Any cleanup code can go here
    }
  }

  @override
  void initState() {
    fetchInvoices(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double _appBarElevation = 0;
  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.pop(context),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Invoices List",
      ),
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreateInvoice(),
          ));
        },
      ),
      body: Container(
          // color: (themeChangeProvider.darkTheme)
          //     ? Colors.blueGrey[800]
          //     : Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: primaryGradient(context),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<Groups>(builder: (context, groupData, child) {
                  return groupData.invoices.length > 0
                      ? ListView.separated(
                          padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
                          itemCount: groupData.invoices.length,
                          itemBuilder: (context, index) {
                            Invoices invoice = groupData.invoices[index];
                            return Card(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                borderOnForeground: false,
                                child: Container(
                                    decoration: cardDecoration(
                                        gradient: plainCardGradient(context),
                                        context: context),
                                    child: Column(children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 12.0, top: 12.0, right: 12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                invoice.type,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16.0,
                                                    // ignore: deprecated_member_use
                                                    color: Theme.of(context)
                                                        .textSelectionTheme
                                                        .selectionHandleColor,
                                                    fontFamily: 'SegoeUI'),
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 12.0, right: 12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                subtitle2(
                                                    text: "Due date",
                                                    color: Theme.of(context)
                                                        .textSelectionTheme
                                                        .selectionHandleColor,
                                                    textAlign: TextAlign.start),
                                                subtitle1(
                                                    text: invoice.dueDate,
                                                    color: Theme.of(context)
                                                        .textSelectionTheme
                                                        .selectionHandleColor,
                                                    textAlign: TextAlign.start)
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                customTitle(
                                                  text:
                                                      "${groupObject.groupCurrency} ",
                                                  fontSize: 18.0,
                                                  // ignore: deprecated_member_use
                                                  color: Theme.of(context)
                                                      .textSelectionTheme
                                                      .selectionHandleColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                heading2(
                                                  text: currencyFormat.format(
                                                          double.tryParse(invoice
                                                              .amountPayable)) ??
                                                      0.0,
                                                  color: Theme.of(context)
                                                      .textSelectionTheme
                                                      .selectionHandleColor,
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
                                      DottedLine(
                                        direction: Axis.horizontal,
                                        lineLength: double.infinity,
                                        lineThickness: 0.5,
                                        dashLength: 2.0,
                                        dashColor: Colors.black45,
                                        dashRadius: 0.0,
                                        dashGapLength: 2.0,
                                        dashGapColor: Colors.transparent,
                                        dashGapRadius: 0.0,
                                      ),
                                      Center(
                                        child: groupObject.isGroupAdmin
                                            ? plainButtonWithIcon(
                                                text: "VOID INVOICE",
                                                size: 14.0,
                                                spacing: 2.0,
                                                color: Colors.red,
                                                iconData: Icons.delete,
                                                action: () {
                                                  twoAlertDialog(
                                                    action: () {
                                                      _voidMemberInvoice(
                                                          context, invoice.id);
                                                    },
                                                    context: context,
                                                    message:
                                                        "Are you sure you want to void ${invoice.type} to ${invoice.member}?",
                                                    title: "Confirm Action",
                                                  );
                                                })
                                            : Container(),
                                      ),
                                    ])));
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Theme.of(context).dividerColor,
                              height: 6.0,
                            );
                          },
                        )
                      : betterEmptyList(
                          message: "Sorry, you have not added any invoices");
                })),
    );
  }
}
