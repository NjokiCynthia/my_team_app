import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/endpoint-url.dart';
import 'package:chamasoft/helpers/post-to-server.dart';
import 'package:flutter/cupertino.dart';

class LoanProduct {
  String id;
  String name;
  String interestRate;
  String loanInterestRatePer;
  String interestType;

  LoanProduct(
      {this.id,
      this.name,
      this.interestRate,
      this.loanInterestRatePer,
      this.interestType});
}

class ChamasoftLoans with ChangeNotifier {
  List<LoanProduct> _loanProducts = [];

  List<LoanProduct> get loanProducts {
    return [..._loanProducts];
  }

  String _userId;
  String _identity;
  String _currentGroupId;

  ChamasoftLoans(String _userId, String _identity, String _currentGroupId) {
    this._userId = _userId;
    this._identity = _identity;
    this._currentGroupId = _currentGroupId;
  }

  String get currentGroupId {
    return _currentGroupId;
  }

  String get userId {
    return _userId;
  }

  Future<void> fetchLoanProducts() async {
    final url = EndpointUrl.GET_CHAMASOFT_LOAN_PRODUCTS;
    try {
      try {
        final postRequest = json.encode({
          "user_id": _userId,
          "group_id": _currentGroupId,
        });

        final response = await PostToServer.post(postRequest, url);

        print("Loan products $response");
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }
}
