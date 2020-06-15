import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'create-loan-type.dart';

List<dynamic> loanTypesList = [
  {
    "id": 1,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 2,500"
  },
  {
    "id": 2,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 1,500"
  },
  {
    "id": 3,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 2,100"
  },
  {
    "id": 4,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 2,500"
  },
  {
    "id": 5,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 1,500"
  },
  {
    "id": 6,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 2,100"
  },
  {
    "id": 1,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 2,500"
  },
  {
    "id": 2,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 1,500"
  },
  {
    "id": 3,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 2,100"
  },
  {
    "id": 4,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 2,500"
  },
  {
    "id": 5,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 1,500"
  },
  {
    "id": 6,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 2,100"
  },
  {
    "id": 7,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 2,500"
  },
  {
    "id": 8,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 1,500"
  },
  {
    "id": 9,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 2,100"
  },
  {
    "id": 10,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 2,500"
  },
  {
    "id": 11,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 1,500"
  },
  {
    "id": 12,
    "name": "Witcher School Fund",
    "type": "Regular",
    "frequency": "Once a month",
    "amount": "Ksh 2,100"
  },
];

class ListLoanTypes extends StatefulWidget {
  @override
  _ListLoanTypesState createState() => _ListLoanTypesState();
}

class _ListLoanTypesState extends State<ListLoanTypes> {
  @override
  void initState() {
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
        title: "Loan Types List",
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreateLoanType(),
          ));
        },
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: primaryGradient(context),
          child: Consumer<Groups>(builder: (context, groupData, child) {
            return ListView.separated(
              padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
              itemCount: groupData.loanTypes.length,
              itemBuilder: (context, index) {
                LoanType loanType = groupData.loanTypes[index];
                return ListTile(
                  dense: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${loanType.name}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textSelectionHandleColor,
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
                                            'Repayment Period: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .textSelectionHandleColor
                                                  .withOpacity(0.5),
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          Text(
                                            '${loanType.repaymentPeriod}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Theme.of(context)
                                                  .textSelectionHandleColor
                                                  .withOpacity(0.5),
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Loan Amount: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .textSelectionHandleColor
                                                  .withOpacity(0.5),
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          Text(
                                            '${loanType.loanAmount}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Theme.of(context)
                                                  .textSelectionHandleColor
                                                  .withOpacity(0.5),
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Interest rate: ${loanType.interestRate}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Theme.of(context)
                                              .textSelectionHandleColor
                                              .withOpacity(0.5),
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      Text(
                                        'Loan Processing: ${loanType.loanProcessing}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Theme.of(context)
                                              .textSelectionHandleColor
                                              .withOpacity(0.5),
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      Text(
                                        'Guarantors: ${loanType.guarantors}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Theme.of(context)
                                              .textSelectionHandleColor
                                              .withOpacity(0.5),
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      Text(
                                        'Late Payment Fines: ${loanType.latePaymentFines}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Theme.of(context)
                                              .textSelectionHandleColor
                                              .withOpacity(0.5),
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      Text(
                                        'Outstanding Payment Fines: ${loanType.outstandingPaymentFines}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Theme.of(context)
                                              .textSelectionHandleColor
                                              .withOpacity(0.5),
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
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
            );
          })),
    );
  }
}
