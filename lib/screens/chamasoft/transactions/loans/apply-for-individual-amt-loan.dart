import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/providers/access_token.dart';
import 'package:chamasoft/providers/chamasoft-loans.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/amt-individual-stepper.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ApplyIndividualAmtLoan extends StatefulWidget {
  Map<String, dynamic> formLoadData;
  List<LoanProduct> loanProducts;
  ApplyIndividualAmtLoan({this.formLoadData, this.loanProducts});

  @override
  _ApplyIndividualAmtLoanState createState() => _ApplyIndividualAmtLoanState();
}

class _ApplyIndividualAmtLoanState extends State<ApplyIndividualAmtLoan> {
  double _appBarElevation = 0;
  ScrollController _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //  List<MembersFilterEntry> selectedMembersList = [];
  Group group;
  Future<void> fetchLoanProducts() async {
    final accessTokenProvider =
        Provider.of<AccessTokenProvider>(context, listen: false);
    final accessToken = accessTokenProvider.accessToken;
    group = Provider.of<Groups>(context, listen: false).getCurrentGroup();

    if (accessToken != null) {
      final url =
          'https://ngo-api.sandbox.co.ke:8631/api/loans/get-mobile-loan-products';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final body = {
        "referral_code": group.referralCode,
        "is_collective": 1,
        //group.isCollective
        //1
      };
      // final body = {"referral_code": "VTW1633", "is_collective": 1};
      print('fOR AN INDIVIDUAL GROUP');
      print(body);
      print(group.referralCode);

      try {
        final response = await http.post(Uri.parse(url),
            headers: headers, body: json.encode(body));

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          print('These are my loan products');
          print(responseData);
          setState(() {
            loanProducts =
                responseData['entities'].cast<Map<String, dynamic>>();
          });
        } else {
          throw Exception(
              'Failed to fetch loan applications. Status code: ${response.statusCode}');
        }
      } catch (error) {
        throw Exception('Error fetching loan applications: $error');
      }
    } else {
      throw Exception('Access token is null');
    }
  }

  @override
  void initState() {
    fetchLoanProducts();
    super.initState();
  }

  List<Map<String, dynamic>> loanProducts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.pop(context),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Apply AMT Individual Loan",
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              children: [
                toolTip(
                  context: context,
                  title: "Note that...",
                  message:
                      "Apply quick loan from Amt guaranteed by your savings and fellow group members.",
                ),
                loanProducts.isEmpty
                    ? CircularProgressIndicator()
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: loanProducts.length,
                          itemBuilder: (context, index) {
                            final loanProduct = loanProducts[index];
                            return AmtLoanProduct(
                              loanProduct: loanProduct,
                              onProductSelected: (selectedOption) {
                                // Handle selected option
                                print('Selected option: $selectedOption');
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AmtLoanProduct extends StatelessWidget {
  final Map<String, dynamic> loanProduct;
  //final Function(String) onProductSelected;
  final Function(Map<String, dynamic>) onProductSelected;

  const AmtLoanProduct({
    Key key,
    this.loanProduct,
    this.onProductSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 10.0, left: 10.0),
      child: InkWell(
        onTap: () {
          if (onProductSelected != null) {
            onProductSelected(loanProduct);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    IndividualLoanStepper(selectedLoanProduct: loanProduct),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          // height: 182,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
              color: const Color.fromRGBO(255, 255, 255, 1.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x00000000).withOpacity(.2),
                  offset: const Offset(0, 5),
                  blurRadius: 16,
                  spreadRadius: -8,
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    loanProduct['name'] ?? '',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    '${loanProduct['interestRate']}% interest',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'Grace period:',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                  Text(
                    '${loanProduct['gracePeriod']} months',
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Visibility(
                visible: loanProduct['times'] != null,
                child: Row(
                  children: [
                    Text(loanProduct['times'].toString()),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Times your Saving amount.')
                  ],
                ),
              ),
              Visibility(
                visible: loanProduct['times'] == null,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Minimum amount:',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                        Text(
                          'KES ${currencyFormat.format(double.tryParse(loanProduct['minAmount'] ?? ''))}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Maximum amount:',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                        Text(
                          'KES ${currencyFormat.format(double.tryParse(loanProduct['maxAmount'] ?? ''))}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Visibility(
                visible: loanProduct['repaymentPeriodType'] == '2',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Minimum Repayment Period:'),
                        Text('${loanProduct['minRepaymentPeriod']} months'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Maximum Repayment Period:'),
                        Text('${loanProduct['maxRepaymentPeriod']} months')
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: loanProduct['repaymentPeriodType'] == '1',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Maximum Repayment Period:'),
                    Text('${loanProduct['repaymentPeriod']} months')
                  ],
                ),
              ),
              // SizedBox(
              //   height: 5,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
