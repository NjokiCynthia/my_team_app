import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/create-invoice.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/empty_screens.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ListInvoices extends StatefulWidget {
  @override
  _ListInvoicesState createState() => _ListInvoicesState();
}

class _ListInvoicesState extends State<ListInvoices> {
  Future<void> fetchInvoices(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Invoices List",
      ),
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
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: primaryGradient(context),
          child: Consumer<Groups>(builder: (context, groupData, child) {
            return groupData.invoices.length > 0
                ? ListView.separated(
                    padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
                    itemCount: groupData.invoices.length,
                    itemBuilder: (context, index) {
                      Invoices invoice = groupData.invoices[index];
                      return ListTile(
                        dense: true,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.label,
                                        color: Colors.blueGrey,
                                      ),
                                      SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${invoice.member}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  // ignore: deprecated_member_use
                                                  .textSelectionTheme
                                                  .selectionHandleColor,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    'Balance: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(context)
                                                          .textSelectionTheme
                                                          .selectionHandleColor
                                                          .withOpacity(0.5),
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${invoice.amountPayable}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Theme.of(context)
                                                          .textSelectionTheme
                                                          .selectionHandleColor
                                                          .withOpacity(0.7),
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: circleIconButton(
                                          icon: Icons.edit,
                                          backgroundColor:
                                              primaryColor.withOpacity(.3),
                                          color: primaryColor,
                                          iconSize: 18.0,
                                          padding: 0.0,
                                          onPressed: () async {
                                            // await Navigator.of(context)
                                            //     .push(MaterialPageRoute(
                                            //   builder: (context) =>
                                            //       EditFineType(
                                            //     fineCategoryId:
                                            //         int.parse(fineType.id),
                                            //   ),
                                            // ));
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
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
