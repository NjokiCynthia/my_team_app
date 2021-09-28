import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/endpoint-url.dart';
import 'package:chamasoft/helpers/post-to-server.dart';
import 'package:flutter/cupertino.dart';

class LoanProduct {
  String id;
  String name;
  String description;
  String loanRepaymentPeriodType;
  String fixedRepaymentPeriod;
  String minimumRepaymentPeriod;
  String maximumRepaymentPeriod;
  String interestRate;
  String interestRatePer;
  String interestType;

  LoanProduct(
      {this.id,
      this.name,
      this.description,
      this.loanRepaymentPeriodType,
      this.fixedRepaymentPeriod,
      this.minimumRepaymentPeriod,
      this.maximumRepaymentPeriod,
      this.interestRate,
      this.interestRatePer,
      this.interestType});
}

class ChamasoftLoans with ChangeNotifier {
  List<LoanProduct> _loanProducts = [];

  List<LoanProduct> get getLoanProducts {
    return [..._loanProducts];
  }

  void resetLoanProducts() {
    _loanProducts = [];
    notifyListeners();
  }

  String _userId;
  String _currentGroupId;

  ChamasoftLoans(String _userId, String _identity, String _currentGroupId) {
    this._userId = _userId;
    this._currentGroupId = _currentGroupId;
  }

  String get currentGroupId {
    return _currentGroupId;
  }

  String get userId {
    return _userId;
  }

  void addLoanProducts({List<dynamic> loanProducts}) {
    if (loanProducts.length > 0) {
      for (var loanProduct in loanProducts) {
        final _loanProduct = LoanProduct(
            id: loanProduct['id']..toString(),
            name: loanProduct['name']..toString(),
            description: loanProduct['description']..toString(),
            loanRepaymentPeriodType: loanProduct['loan_repayment_period_type']
              ..toString(),
            fixedRepaymentPeriod: loanProduct['fixed_repayment_period']
              ..toString(),
            minimumRepaymentPeriod: loanProduct['minimum_repayment_period']
              ..toString(),
            maximumRepaymentPeriod: loanProduct['maximum_repayment_period']
              ..toString(),
            interestRate: loanProduct['interest_rate']..toString(),
            interestRatePer: loanProduct['interest_rate_per']..toString(),
            interestType: loanProduct['interest_type']..toString());

        _loanProducts.add(_loanProduct);
      }
    }
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
        addLoanProducts(loanProducts: response['loan_products']);
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }
}
