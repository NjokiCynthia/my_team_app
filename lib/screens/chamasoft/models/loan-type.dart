import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';

class LoanType {
  final String id;
  final String details;
  final String loanName;
  final String dateTime;

  LoanType({this.id, this.details, this.loanName, this.dateTime});
}

List<LoanType> loantype = [
  LoanType(
      id: '1',
      details: 'Limited to KES 8,000 per Semester',
      loanName: 'Education Loan',
      dateTime: DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: 90)))),
  //DateUtils.dateOnly(DateTime.now().add(const Duration(days: 90)))),
  LoanType(
      id: '2',
      details: 'Avalable Up to KES 10,000',
      loanName: 'Emmergency Loan',
      dateTime: DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: 30)))),
  // DateUtils.dateOnly(DateTime.now().add(const Duration(days: 30)))),
  LoanType(
      id: '3',
      details: 'Avilable only 3 times, to Employees and Busines Person(s))',
      loanName: 'Normal Loan',
      dateTime: DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: 30)))),
  // DateUtils.dateOnly(DateTime.now().add(const Duration(days: 30)))),
  LoanType(
      id: '4',
      details: 'payable with interest, Limit to KES 1,000,000',
      loanName: 'Business Loan',
      dateTime: DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: 400)))),
  // DateUtils.dateOnly(DateTime.now().add(const Duration(days: 400)))),
  LoanType(
      id: '5',
      details: 'Available From August to Dec',
      loanName: 'Holiday Loan',
      dateTime: DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: 90)))),
  // DateUtils.dateOnly(DateTime.now().add(const Duration(days: 90)))),
  LoanType(
      id: '6',
      details: 'Due in 24 Hrs, Limit KES 25,000',
      loanName: 'Payday Loans',
      dateTime: DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: 1)))),
  //  DateUtils.dateOnly(DateTime.now().add(const Duration(days: 1)))),
  LoanType(
    id: '7',
    details: 'ShortTerm Loan for upto a month, for employees only',
    loanName: 'Credit Card Advance Loan',
    dateTime: DateFormat('yyyy-MM-dd')
        .format(DateTime.now().add(const Duration(days: 30))),
    //  DateUtils.dateOnly(DateTime.now().add(const Duration(days: 30)))),
    // LoanType(
    //     id: '8',
    //     details: 'Available From August to Dec and Limited to KES 125,000',
    //     loanName: 'Holiday',
    //     dateTime:
    //         DateUtils.dateOnly(DateTime.now().add(const Duration(days: 180)))),
  )
];
