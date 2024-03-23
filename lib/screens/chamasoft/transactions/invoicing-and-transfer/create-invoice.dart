import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/models/members-filter-entry.dart';
import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/date-picker.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/custom-dropdown.dart';
import 'package:chamasoft/widgets/dialogs.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../select-member.dart';
import 'fine-member.dart';

List<NamesListItem> refundMethods = [
  NamesListItem(id: 1, name: "Cash"),
  NamesListItem(id: 2, name: "Cheque"),
  NamesListItem(id: 3, name: "MPesa"),
];

List<NamesListItem> contributions = [
  NamesListItem(id: 1, name: "Kikopey Land Leasing"),
  NamesListItem(id: 2, name: "Masaai Foreign Advantage"),
  NamesListItem(id: 3, name: "DVEA Properties"),
];

class CreateInvoice extends StatefulWidget {
  final bool isEditMode;
  final Function(dynamic) onButtonPressed;

  const CreateInvoice({Key key, this.isEditMode, this.onButtonPressed})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreateInvoiceState();
  }
}

class CreateInvoiceState extends State<CreateInvoice> {
  double _appBarElevation = 0;
  ScrollController _scrollController = ScrollController();
  List<MembersFilterEntry> selectedMembersList = [];

  int _invoiceFor;
  int _dropdownValue;

  String _description = "";
  List<NamesListItem> _dropdownItems = [];

  bool _isInit = true;
  Map<String, dynamic> formLoadData = {};

  String _labelText = 'Select  for first--';
  bool _invoiceForEnabled = false;
  final now = DateTime.now();
  static final List<NamesListItem> invoiceTypes = [
    NamesListItem(id: 1, name: "Contribution Invoice"),
    NamesListItem(id: 2, name: "Contribution Invoice Types"),
    NamesListItem(id: 3, name: "Fine Invoice"),
    NamesListItem(id: 4, name: "Miscellaneous Invoice"),
  ];
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _fetchDefaultValues(context);
    }
    super.didChangeDependencies();
  }

  Future<void> _fetchDefaultValues(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    });
    try {
      formLoadData = await Provider.of<Groups>(context, listen: false)
          .loadInitialFormData(
              contr: true, fineOptions: true, memberOngoingLoans: true);
      setState(() {
        _isInit = false;
      });
    } on CustomException catch (error) {
      StatusHandler().handleStatus(context: context, error: error);
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _populatePaymentFor() {
    if (_invoiceFor == 1) {
      setState(() {
        _dropdownValue = null;
        _dropdownItems = formLoadData.containsKey("contributionOptions")
            ? formLoadData["contributionOptions"]
            : [];
        _invoiceForEnabled = true;
        _labelText = "Select Contribution";
      });
    } else if (_invoiceFor == 2) {
      setState(() {
        _dropdownValue = null;
        _dropdownItems = formLoadData.containsKey("contributionOptions")
            ? formLoadData["contributionOptions"]
            : [];
        _invoiceForEnabled = true;
        _labelText = "Select Contribution";
      });
    } else if (_invoiceFor == 3) {
      setState(() {
        _dropdownValue = null;
        _dropdownItems = formLoadData.containsKey("finesOptions")
            ? formLoadData["finesOptions"]
            : [];
        _invoiceForEnabled = true;
        _labelText = "Select Fine Type";
      });
    } else {
      setState(() {
        _dropdownValue = null;
        _dropdownItems = [];
        _invoiceForEnabled = false;
        _labelText = "Select invoice for first---";
      });
    }
  }

  Widget customDropDown(
      {int selectedItem,
      String labelText,
      Function onChanged,
      Function validator,
      List<NamesListItem> listItems,
      bool enabled}) {
    return new Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).cardColor,
      ),
      child: new DropdownButtonFormField(
        isExpanded: true,
        isDense: true,
        value: selectedItem,
        items: listItems.map((NamesListItem item) {
          return new DropdownMenuItem(
            value: item.id,
            child: new Text(
              item.name,
              style: inputTextStyle(),
            ),
          );
        }).toList(),
        decoration: InputDecoration(
            isDense: true,
            filled: false,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelStyle: inputTextStyle(),
            hintStyle: inputTextStyle(),
            errorStyle: inputTextStyle(),
            hintText: labelText,
            labelText: selectedItem == null ? labelText : labelText,
            enabled: enabled ?? true,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).hintColor,
                width: 1.0,
              ),
            )),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  Widget buildDropDown() {
    return FormField(
      builder: (FormFieldState state) {
        return DropdownButtonHideUnderline(
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 7,
                child: customDropDown(
                    selectedItem:
                        //invoiceTypeId,
                        _invoiceFor,
                    labelText: 'Select Invoice for',
                    onChanged: (int newValue) {
                      setState(() {
                        // invoiceTypeId = newValue;
                        _invoiceFor = newValue;

                        _populatePaymentFor();
                      });
                    },
                    validator: (newValue) {
                      if (newValue == null) {
                        return "Field is required";
                      }
                      return null;
                    },
                    listItems: invoiceTypes,
                    enabled: _invoiceForEnabled),
              ),
              Visibility(
                  visible: _invoiceFor != 4,
                  child: Expanded(flex: 1, child: SizedBox(height: 10))),
              Visibility(
                visible: _invoiceFor != 4,
                child: Expanded(
                  flex: 7,
                  child: customDropDown(
                      selectedItem: _dropdownValue,
                      labelText: _labelText,
                      onChanged: (int newValue) {
                        setState(() {
                          _dropdownValue = newValue;
                        });
                      },
                      validator: (newValue) {
                        if (_invoiceFor != 4 && newValue == null) {
                          return "Field is required";
                        }
                        return null;
                      },
                      listItems: _dropdownItems,
                      enabled: _invoiceForEnabled),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Iterable<Widget> get memberWidgets sync* {
    for (MembersFilterEntry member in selectedMembersList) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: Chip(
//          avatar: CircleAvatar(child: Text(member.initials)),
          label: Text(member.name),
          onDeleted: () {
            setState(() {
              selectedMembersList.removeWhere((MembersFilterEntry entry) {
                return entry.name == member.name;
              });
            });
          },
        ),
      );
    }
  }

  //final formKey = new GlobalKey<FormState>();
  bool toolTipIsVisible = true;
  DateTime invoiceDate = DateTime.now();
  DateTime dueDate = DateTime.now();

  String formattedInvoiceDate; // Variable to store formatted invoice date
  String formattedDueDate;
  int invoiceTypeId;
  int memberTypeId;
  int contributionId;
  double amount;
  String description;
  final _formKey = GlobalKey<FormState>();
  Auth user;
  Group group;

  bool _isFormEnabled = true;
  var _isLoading = false;

  void createinvoiceApplication(BuildContext context) async {
    group = Provider.of<Groups>(context, listen: false).getCurrentGroup();
    user = Provider.of<Auth>(context, listen: false);
    Map<String, dynamic> formData = {
      'group_id': group.groupId,
      "user_id": user.id,
      "send_sms_notification": "1",
      "send_email_notification": "1",
      "description": description,
      "amount_payable": amount,
      "invoice_date": formattedInvoiceDate,
      //"1711107162",
      "due_date": formattedDueDate,
      //"1711107162",
      "send_to": memberTypeId,
      "member_ids": selectedMembersList.map((MembersFilterEntry mem) {
            return (mem.memberId);
          }).toList() ??
          [],
      "member_names": selectedMembersList.map((MembersFilterEntry mem) {
            return (mem.name);
          }).toList() ??
          [],
      "contribution_id": _dropdownValue,
      "type": _invoiceFor,
    };

    print('form data is: $formData');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    });
    try {
      String response = await Provider.of<Groups>(context, listen: false)
          .createInvoice(formData);
      print('I want to see this point');
      print(response);
      Navigator.pop(context);
      // ignore: deprecated_member_use
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "You have successfully created an invoice",
      )));

      Future.delayed(const Duration(milliseconds: 2500), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) {}));
      });
    } on CustomException catch (error) {
      Navigator.pop(context);

      // ignore: deprecated_member_use
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Error Creating an invoice. ${error.message} ",
      )));
    }
  }
  //   } on CustomException catch (error) {
  //     StatusHandler().showDialogWithAction(
  //         context: context,
  //         message: error.toString(),
  //         function: () =>
  //             Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                 // builder: (_) => ApplyLoan(
  //                 //       isInit: false,
  //                 //     )
  //                 )),
  //         dismissible: true);
  //   } finally {}
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.times,
        title: "Create Invoices",
      ),
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).backgroundColor,
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
              Expanded(
                child: Container(
                  padding: inputPagePadding,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              // flex: 2,
                              child: DatePicker(
                                labelText: 'Select Invoice Date',
                                lastDate: DateTime.now()
                                    .add(Duration(days: 365 * 10)),
                                selectedDate: invoiceDate == null
                                    ? DateTime.now()
                                    : invoiceDate,
                                selectDate: (selectedDate) {
                                  setState(() {
                                    invoiceDate = selectedDate;
                                    formattedInvoiceDate =
                                        DateFormat('yyMMddHHmm')
                                            .format(invoiceDate);

                                    // Print the formatted date
                                    print(formattedInvoiceDate);
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              //flex: 2,
                              child: DatePicker(
                                labelText: 'Select Due Date',
                                lastDate: DateTime.now()
                                    .add(Duration(days: 365 * 10)),
                                selectedDate:
                                    dueDate == null ? DateTime.now() : dueDate,
                                selectDate: (selectedDate) {
                                  setState(() {
                                    dueDate = selectedDate;
                                    formattedDueDate = DateFormat('yyMMddHHmm')
                                        .format(dueDate);

                                    // Print the formatted date
                                    print(formattedDueDate);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        // CustomDropDownButton(
                        //   labelText: 'Select invoice type',
                        //   listItems: invoiceTypes,
                        //   selectedItem: invoiceTypeId,
                        //   onChanged: (value) {
                        //     setState(() {
                        //       invoiceTypeId = value;
                        //     });
                        //   },
                        // ),
                        Visibility(
                            visible: _invoiceFor == 4,
                            child: SizedBox(height: 10)),
                        Visibility(
                          visible: _invoiceFor == 4,
                          child: simpleTextInputField(
                              context: context,
                              labelText: 'Short Description (Optional)',
                              onChanged: (value) {
                                setState(() {
                                  _description = value;
                                });
                              }),
                        ),
                        // CustomDropDownButton(
                        //   labelText: 'Select Contribution ',
                        //   listItems: contributions,
                        //   selectedItem: contributionId,
                        //   onChanged: (value) {
                        //     setState(() {
                        //       contributionId = value;
                        //     });
                        //   },
                        // ),
                        buildDropDown(),
                        Visibility(
                            visible: _invoiceFor == 4,
                            child: SizedBox(height: 10)),
                        Visibility(
                          visible: _invoiceFor == 4,
                          child: simpleTextInputField(
                              context: context,
                              labelText: 'Short Description (Optional)',
                              onChanged: (value) {
                                setState(() {
                                  _description = value;
                                });
                              }),
                        ),
                        SizedBox(height: 10),
                        CustomDropDownButton(
                          labelText: 'Select Member',
                          listItems: memberTypes,
                          selectedItem: memberTypeId,
                          onChanged: (selected) async {
                            if (selected == 1) {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectMember(
                                            initialMembersList:
                                                selectedMembersList,
                                            //membersList: memberOptions,
                                          ))).then((value) {
                                setState(() {
                                  memberTypeId = selected;
                                  selectedMembersList = value;
                                });
                              });
                            } else {
                              setState(() {
                                memberTypeId = selected;
                              });
                            }
                          },
                        ),
                        Visibility(
                          visible: memberTypeId == 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Wrap(
                                children: memberWidgets.toList(),
                              ),
                              TextButton(
                                onPressed: () async {
                                  //open select members dialog
                                  selectedMembersList = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SelectMember(
                                                initialMembersList:
                                                    selectedMembersList,
                                              )));
                                },
                                child: Text(
                                  'Select more members',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                            onPressed: () => createinvoiceApplication(context)
                            //  {
                            // if (invoiceDate != null) {
                            //   // Format the invoiceDate into the desired format "yyMMddHHmm"
                            //   String formattedDate =
                            //       DateFormat('yyMMddHHmm').format(invoiceDate);

                            //   // Print the formatted date
                            //   print(formattedDate); // Output: Formatted date

                            //   // You can use the formattedDate for further processing
                            // } else {
                            //   // Handle case where invoiceDate is null
                            //   print('Please select a date.');
                            // }

                            // print('Due date: $dueDate');
                            // if (formattedInvoiceDate != null &&
                            //     formattedDueDate != null) {
                            //   print('Invoice date: $formattedInvoiceDate');
                            //   print('Due date: $formattedDueDate');
                            //   // Print other values or perform actions here
                            // } else {
                            //   // Handle case where dates are null
                            //   print('Please select invoice and due dates.');
                            // }
                            // print('Invoice Type: $_invoiceFor');
                            // print('Contribution: $_dropdownValue');
                            // print('Member type: $memberTypeId');
                            // print('Amount: $amount');
                            // print('Description: $description');
                            // print(
                            //     'Members selected id: ${selectedMembersList.length}');
                            // selectedMembersList.map((MembersFilterEntry mem) {
                            //   return print(mem.memberId);
                            // }).toList();
                            // print('Members: ${selectedMembersList.length}');
                            // selectedMembersList.map((MembersFilterEntry mem) {
                            //   return print(mem.name);
                            // }).toList();
                            // },
                            ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
