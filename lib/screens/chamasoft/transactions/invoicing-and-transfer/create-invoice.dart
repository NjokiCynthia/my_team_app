import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/date-picker.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

List<NamesListItem> refundMethods = [
  NamesListItem(id: 1, name: "Cash"),
  NamesListItem(id: 2, name: "Cheque"),
  NamesListItem(id: 3, name: "MPesa"),
];
List<NamesListItem> invoiceTypes = [
  NamesListItem(id: 1, name: "Contribution Invoice"),
  NamesListItem(id: 2, name: "Loan Invoice"),
  NamesListItem(id: 3, name: "Goods Invoice"),
];
List<NamesListItem> contributions = [
  NamesListItem(id: 1, name: "Kikopey Land Leasing"),
  NamesListItem(id: 2, name: "Masaai Foreign Advantage"),
  NamesListItem(id: 3, name: "DVEA Properties"),
];
List<NamesListItem> memberTypes = [
  NamesListItem(id: 1, name: "Individual Members"),
  NamesListItem(id: 2, name: "All Members"),
];
List<NamesListItem> groupMembers = [
  NamesListItem(id: 1, name: "Martin Nzuki"),
  NamesListItem(id: 2, name: "Peter Kimutai"),
  NamesListItem(id: 3, name: "Geoffrey Githaiga"),
  NamesListItem(id: 4, name: "Edwin Kapkei"),
];
List<NamesListItem> accounts = [
  NamesListItem(id: 1, name: "KCB Chama Account"),
  NamesListItem(id: 2, name: "Equity Investment Account"),
  NamesListItem(id: 3, name: "NCBA Loop Account"),
];

class CreateInvoice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateInvoiceState();
  }
}

class CreateInvoiceState extends State<CreateInvoice> {
  double _appBarElevation = 0;
  ScrollController _scrollController;

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

  final formKey = new GlobalKey<FormState>();
  bool toolTipIsVisible = true;
  DateTime invoiceDate = DateTime.now();
  DateTime dueDate = DateTime.now();
  int invoiceTypeId;
  int memberTypeId;
  int contributionId;
  double amount;
  String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Create Invoice",
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            toolTip(
                context: context,
                title: "Create and send custom invoices",
                message: "",
                visible: toolTipIsVisible,
                toggleToolTip: () {
                  setState(() {
                    toolTipIsVisible = !toolTipIsVisible;
                  });
                }),
            Container(
              padding: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).backgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: DatePicker(
                          labelText: 'Select Invoice Date',
                          selectedDate: invoiceDate == null
                              ? DateTime.now()
                              : invoiceDate,
                          selectDate: (selectedDate) {
                            setState(() {
                              invoiceDate = selectedDate;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: DatePicker(
                          labelText: 'Select Due Date',
                          selectedDate:
                              dueDate == null ? DateTime.now() : dueDate,
                          selectDate: (selectedDate) {
                            setState(() {
                              dueDate = selectedDate;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomDropDownButton(
                    labelText: 'Select invoice type',
                    listItems: invoiceTypes,
                    selectedItem: invoiceTypeId,
                    onChanged: (value) {
                      setState(() {
                        invoiceTypeId = value;
                      });
                    },
                  ),
                  CustomDropDownButton(
                    labelText: 'Select Contribution ',
                    listItems: contributions,
                    selectedItem: contributionId,
                    onChanged: (value) {
                      setState(() {
                        contributionId = value;
                      });
                    },
                  ),
                  CustomDropDownButton(
                    labelText: 'Select Member',
                    listItems: memberTypes,
                    selectedItem: memberTypeId,
                    onChanged: (value) {
                      setState(() {
                        memberTypeId = value;
                      });
                    },
                  ),
                  amountTextInputField(
                      context: context,
                      labelText: 'Enter Amount to invoice',
                      onChanged: (value) {
                        setState(() {
                          amount = double.parse(value);
                        });
                      }),
                  multilineTextField(
                      context: context,
                      labelText: 'Short Description (Optional)',
                      onChanged: (value) {
                        setState(() {
                          description = value;
                        });
                      }),
                  SizedBox(
                    height: 24,
                  ),
                  defaultButton(
                    context: context,
                    text: "SAVE",
                    onPressed: () {
                      print('Invoice date: $invoiceDate');
                      print('Due date: $dueDate');
                      print('Invoice Type: $invoiceTypeId');
                      print('Contribution: $contributionId');
                      print('Member type: $memberTypeId');
                      print('Amount: $amount');
                      print('Description: $description');
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
