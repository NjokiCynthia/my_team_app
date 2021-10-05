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
  String enableLoanProcessingFee;
  String loanProcessingFeeType;
  String loanProcessingFeeFixedAmount;
  String loanProcessingFeePercentageRate;
  String loanProcessingFeePercentageChargedOn;
  String loanAmountType;
  String minimumLoanAmount;
  String maximumLoanAmount;
  String fixedLoanAmount;
  String guarantors;
  String enableLoanGuarantors;

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
      this.interestType,
      this.enableLoanProcessingFee,
      this.loanProcessingFeeType,
      this.loanProcessingFeeFixedAmount,
      this.loanProcessingFeePercentageRate,
      this.loanProcessingFeePercentageChargedOn,
      this.loanAmountType,
      this.minimumLoanAmount,
      this.maximumLoanAmount,
      this.fixedLoanAmount,
      this.guarantors,
      this.enableLoanGuarantors});
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

  ChamasoftLoans(String _userId, String _currentGroupId) {
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
          interestType: loanProduct['interest_type']..toString(),
          enableLoanProcessingFee: loanProduct['enable_loan_processing_fee']
            ..toString(),
          loanProcessingFeeType: loanProduct['loan_processing_fee_type']
            ..toString(),
          loanProcessingFeeFixedAmount:
              loanProduct['loan_processing_fee_fixed_amount']..toString(),
          loanProcessingFeePercentageRate:
              loanProduct['loan_processing_fee_percentage_rate']..toString(),
          loanProcessingFeePercentageChargedOn:
              loanProduct['loan_processing_fee_percentage_charged_on']
                ..toString(),
          loanAmountType: loanProduct['loan_amount_type']..toString(),
          minimumLoanAmount: loanProduct['minimum_loan_amount']..toString(),
          maximumLoanAmount: loanProduct['maximum_loan_amount']..toString(),
          fixedLoanAmount: loanProduct['fixed_loan_amount']..toString(),
          guarantors: loanProduct['minimum_guarantors']..toString(),
          enableLoanGuarantors: loanProduct['enable_loan_guarantors']
            ..toString(),
        );
        _loanProducts.add(_loanProduct);
      }
    }
  }

  Future<List<LoanProduct>> fetchLoanProducts() async {
    final url = EndpointUrl.GET_CHAMASOFT_LOAN_PRODUCTS;
    try {
      try {
        final postRequest = json.encode({
          "user_id": _userId,
          "group_id": _currentGroupId,
        });

        final response = await PostToServer.post(postRequest, url);
        addLoanProducts(loanProducts: response['loan_products']);
        return getLoanProducts;
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<String> submitLoanApplication(Map<String, dynamic> formData) async {
    final url = EndpointUrl.CREATE_CHAMASOFT_LOAN_APPLICATION;
    try {
      try {
        formData['user_id'] = _userId;

        final postRequest = json.encode(formData);

        final response = await PostToServer.post(postRequest, url);

        return response['message'];
      } catch (error) {
        throw CustomException(message: ERROR_MESSAGE);
      }
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }

  Future<Map<String, dynamic>> fetchLoanCalculator(
      Map<String, dynamic> formData) async {
    final url = EndpointUrl.GET_CHAMASOFT_LOAN_CALCULATOR;
    try {
      formData['user_id'] = _userId;
      formData['group_id'] = _currentGroupId;
      final postRequest = json.encode(formData);
      try {
        final response = await PostToServer.post(postRequest, url);
        Map<String, dynamic> _loanCalculator = {
          "amortizationTotals": {
            "totalPayable": double.tryParse(response['amortization_totals']
                        ['total_payable']
                    .toString()) ??
                0.0,
            "totalPrinciple": double.tryParse(response['amortization_totals']
                        ['total_interest']
                    .toString()) ??
                0.0,
            "totalInterest": double.tryParse(response['amortization_totals']
                        ['total_principle']
                    .toString()) ??
                0.0,
          },
          "breakdown": response['breakdown']
              .map((breakdown) => {
                    "dueDate": breakdown['due_date'],
                    "amountPayable": double.tryParse(
                            breakdown['amount_payable'].toString()) ??
                        0.0,
                    "principlePayable": double.tryParse(
                            breakdown['principle_payable'].toString()) ??
                        0.0,
                    "interestPayable": double.tryParse(
                            breakdown['interest_payable'].toString()) ??
                        0.0,
                    "totalInterestPayable": double.tryParse(
                            breakdown['total_intrest_payable'].toString()) ??
                        0.0,
                    "balance":
                        double.tryParse(breakdown['balance'].toString()) ?? 0.0
                  })
              .toList(),
        };

        return _loanCalculator;
      } on CustomException catch (error) {
        throw CustomException(message: error.message, status: error.status);
      } catch (error) {
        print("error $error");
        throw CustomException(message: ERROR_MESSAGE);
      }
    } on CustomException catch (error) {
      throw CustomException(message: error.message, status: error.status);
    } catch (error) {
      throw CustomException(message: ERROR_MESSAGE);
    }
  }
}
