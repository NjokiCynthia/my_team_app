import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';

List<NamesListItem> loanAmountTypes = [
  NamesListItem(id: 1, name: "Based on Amount Range"),
  NamesListItem(id: 2, name: "Based on Member Savings"),
];

List<NamesListItem> interestTypes = [
  NamesListItem(id: 1, name: "Fixed Balance"),
  NamesListItem(id: 2, name: "Reducing Balance"),
];

List<NamesListItem> loanInterestRatePer = [
  NamesListItem(id: 1, name: "Per Day"),
  NamesListItem(id: 2, name: "Per Week"),
  NamesListItem(id: 3, name: "Per Month"),
  NamesListItem(id: 4, name: "Per Annum"),
  NamesListItem(id: 5, name: "For the whole loan repayment period"),
];

List<NamesListItem> loanRepaymentType = [
  NamesListItem(id: 1, name: "Fixed Repayment Period"),
  NamesListItem(id: 2, name: "Varying Repayment Period"),
];

List<NamesListItem> lateLoanPaymentFineTypes = [
  NamesListItem(id: 3, name: "A One off Fine Amount per Installment"),
  NamesListItem(id: 1, name: "A Fixed Fine Amount"),
  NamesListItem(id: 2, name: "A Percentage (%) Fine"),
];

List<NamesListItem> loanGracePeriods = [
  NamesListItem(id: 1, name: "One Month"),
  NamesListItem(id: 2, name: "Two Months"),
  NamesListItem(id: 3, name: "Three Months"),
  NamesListItem(id: 4, name: "Four Months"),
  NamesListItem(id: 5, name: "Five Months"),
  NamesListItem(id: 6, name: "Six Months"),
  NamesListItem(id: 7, name: "Seven Months"),
  NamesListItem(id: 8, name: "Eight Months"),
  NamesListItem(id: 9, name: "Nine Months"),
  NamesListItem(id: 10, name: "Ten Months"),
  NamesListItem(id: 11, name: "Eleven Months"),
  NamesListItem(id: 12, name: "One Year"),
];

List<NamesListItem> latePaymentsFineFrequency = [
  NamesListItem(id: 1, name: "Daily"),
  NamesListItem(id: 2, name: "Weekly"),
  NamesListItem(id: 3, name: "Monthly"),
  NamesListItem(id: 4, name: "Yearly"),
];

List<NamesListItem> fixedAmountFineFrequencyOn = [
  NamesListItem(id: 1, name: "Each Outstanding Installment"),
  NamesListItem(id: 2, name: "Total Outstanding Balance"),
];

List<NamesListItem> percentageFineOn = [
  NamesListItem(id: 1, name: "Loan Installment Balance"),
  NamesListItem(id: 2, name: "Loan Amount"),
  NamesListItem(id: 3, name: "Total Unpaid Loan Amount"),
];

List<NamesListItem> oneOffFineTypes = [
  NamesListItem(id: 1, name: "Fixed Fine"),
  NamesListItem(id: 2, name: "Percentage Fine"),
];

List<NamesListItem> oneOffPercentageRateOn = [
  NamesListItem(id: 1, name: "Loan Installment Balance"),
  NamesListItem(id: 2, name: "Loan Amount"),
  NamesListItem(id: 3, name: "Total Unpaid Loan Amount"),
];

List<NamesListItem> loanProcessingFeeTypes = [
  NamesListItem(id: 1, name: "A Fixed Amount"),
  NamesListItem(id: 2, name: "A Percentage (%) Value"),
];

List<NamesListItem> loanProcessingFeePercentageChargedOn = [
  NamesListItem(id: 1, name: "Total Loan Amount"),
  NamesListItem(id: 2, name: "Total Loan Principle plus Interest"),
];
