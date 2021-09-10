class LoanType {
  final String id;
  final String details;
  final String loanName;

  LoanType({this.id, this.details, this.loanName});
}

List<LoanType> loantype = [
  LoanType(
      id: '1',
      details: 'Limited to KES 8,000 per Semester',
      loanName: 'Education Loan'),
  LoanType(
      id: '2',
      details: 'Avalable Up to KES 10,000',
      loanName: 'Emmergency Loan'),
  LoanType(
      id: '3',
      details: 'Avilable only 3 times, to Employees and Busines Person(s))',
      loanName: 'Normal Loan'),
  LoanType(
      id: '4',
      details: 'payable with interest, Limit to KES 1,000,000',
      loanName: 'Business Loan'),
  LoanType(
      id: '5',
      details: 'Available From August to Dec',
      loanName: 'Holiday Loan'),
  LoanType(
      id: '6',
      details: 'Due in 24 Hrs, Limit KES 25,000',
      loanName: 'Payday Loans'),
  LoanType(
      id: '7',
      details: 'ShortTerm Loan for upto a month, for employees only',
      loanName: 'Credit Card Advance Loan'),
  LoanType(
      id: '8',
      details: 'Available From August to Dec and Limited to 125M',
      loanName: 'Holiday')
];
