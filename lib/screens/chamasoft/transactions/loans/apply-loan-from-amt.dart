import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/providers/access_token.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/amt_group_loan_stepper.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ApplyLoanFromAmt extends StatefulWidget {
  const ApplyLoanFromAmt({Key key}) : super(key: key);

  @override
  State<ApplyLoanFromAmt> createState() => _ApplyLoanFromAmtState();
}

class _ApplyLoanFromAmtState extends State<ApplyLoanFromAmt> {
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
        "is_collective": group.isCollective
      };
      print('I want to see the referral code');
      print(group.referralCode);
      print('I want to see whether the group is collective');
      print(group.isCollective);
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

  double _appBarElevation = 0;

  List<Map<String, dynamic>> loanProducts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.pop(context),
        // Navigator.of(context)
        //     .popUntil((Route<dynamic> route) => route.isFirst),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Apply AMT Loan",
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                toolTip(
                  context: context,
                  title: "Note that...",
                  message:
                      "Apply quick loan from Amt guaranteed by your savings and fellow group members.",
                ),
                loanProducts.isEmpty
                    ? CircularProgressIndicator() // Or your custom loading widget
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
      padding: EdgeInsets.all(20),
      child: Card(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loan Product name:',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 12),
              ),
              Text(
                loanProduct['name'] ?? '',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('Minimum amount:'),
              //     Text(
              //       'KES ${currencyFormat.format(double.tryParse(loanProduct['minAmount'] ?? ''))}',
              //       // 'KES ${loanProduct['minAmount'] ?? ''}',
              //       style: TextStyle(color: Colors.black),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text('Minimum amount:'),
                  // Text(
                  //   'KES ${currencyFormat.format(double.tryParse(loanProduct['maxAmount'] ?? ""))}',
                  //   style: TextStyle(color: Colors.black),
                  // ),
                ],
              ),
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            if (onProductSelected != null) {
              onProductSelected(loanProduct);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      AmtStepper(selectedLoanProduct: loanProduct),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
