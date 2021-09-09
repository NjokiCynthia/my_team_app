class LoanType {
  final String id;
  final String details;
  final String loanName;

  LoanType({this.id, this.details, this.loanName});
}

List<LoanType> loantype = [
  LoanType(id: '1', details: 'Available only Once', loanName: 'Education'),
  LoanType(id: '2', details: 'Up to KES 10,000', loanName: 'Emmergency'),
  LoanType(id: '3', details: 'Avilable only 3 times', loanName: 'Normal Loan'),
  LoanType(id: '4', details: 'Upto  KES1,000,000', loanName: 'Business Loan'),
  LoanType(
      id: '5', details: 'Available From August to Dec', loanName: 'Holiday'),
  LoanType(
      id: '6', details: 'Available From August to Dec', loanName: 'Holiday'),
  LoanType(
      id: '7', details: 'Available From August to Dec', loanName: 'Holiday'),
  LoanType(
      id: '8', details: 'Available From August to Dec', loanName: 'Holiday')
];
