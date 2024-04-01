import 'dart:convert';

import 'package:chamasoft/providers/access_token.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ApplyLoanFromAmt extends StatefulWidget {
  const ApplyLoanFromAmt({Key key}) : super(key: key);

  @override
  State<ApplyLoanFromAmt> createState() => _ApplyLoanFromAmtState();
}

class _ApplyLoanFromAmtState extends State<ApplyLoanFromAmt> {
  Future<void> fetchLoanProducts() async {
    final accessTokenProvider =
        Provider.of<AccessTokenProvider>(context, listen: false);
    final accessToken = accessTokenProvider.accessToken;

    if (accessToken != null) {
      final url =
          'https://ngo-api.sandbox.co.ke:8631/api/loans/get-mobile-loan-applications';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $accessToken', // Include the access token in the headers
      };
      final body = {"referral_code": "CWA1153", "is_collective": 0};

      try {
        final response = await http.post(Uri.parse(url),
            headers: headers, body: json.encode(body));

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          print('These are my loan products');
          print(responseData);
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          toolTip(
            context: context,
            title: "Note that...",
            message:
                "Apply quick loan from Amt guaranteed by your savings and fellow group members.",
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: loanProducts.length,
            itemBuilder: (context, index) {
              final loanProduct = loanProducts[index];
              return AmtLoanProduct(
                loanProduct: loanProduct,
                onProductSelected: (selectedOption) {
                  // Handle the selected option here
                  print('Selected option: $selectedOption');
                  // You can navigate to the stepper page or perform other actions
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class AmtLoanProduct extends StatelessWidget {
  final Map<String, dynamic> loanProduct;
  final Function(String) onProductSelected;

  const AmtLoanProduct({
    Key key,
    this.loanProduct,
    this.onProductSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        loanProduct['name'] ?? '',
        style: TextStyle(color: Colors.red),
      ),
      subtitle: Text(
        loanProduct['type'] ?? '',
        style: TextStyle(color: Colors.red),
      ),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        if (onProductSelected != null) {
          String selectedOption = loanProduct['_id'] ?? '';
          onProductSelected(selectedOption);
          // Navigator.push(...) if needed
        }
      },
    );
  }
}
