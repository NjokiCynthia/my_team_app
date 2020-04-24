import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';
import 'package:chamasoft/screens/chamasoft/models/string-named-list-item.dart';

List<StringNamesListItem> fineChargeableOnOptions = [
  StringNamesListItem(
      id: "1", name: "chargeable 1 day after contribution date"),
  StringNamesListItem(
      id: "14", name: "chargeable 2 weeks after contribution date"),
  StringNamesListItem(
      id: "last_day_of_the_month",
      name: "chargeable on the last day of the month"),
  StringNamesListItem(
      id: "first_day_of_the_month",
      name: "chargeable on the first day of the month"),
  StringNamesListItem(
      id: "2", name: "chargeable 2 days after contribution date"),
  StringNamesListItem(
      id: "3", name: "chargeable 3 days after contribution date"),
  StringNamesListItem(
      id: "4", name: "chargeable 4 days after contribution date"),
  StringNamesListItem(
      id: "5", name: "chargeable 5 days after contribution date"),
  StringNamesListItem(
      id: "6", name: "chargeable 6 days after contribution date"),
  StringNamesListItem(
      id: "8", name: "chargeable 8 days after contribution date"),
  StringNamesListItem(
      id: "9", name: "chargeable 9 days after contribution date"),
  StringNamesListItem(
      id: "10", name: "chargeable 10 days after contribution date"),
  StringNamesListItem(
      id: "11", name: "chargeable 11 days after contribution date"),
  StringNamesListItem(
      id: "12", name: "chargeable 12 days after contribution date"),
  StringNamesListItem(
      id: "13", name: "chargeable 13 days after contribution date"),
  StringNamesListItem(
      id: "15", name: "chargeable 15 days after contribution date"),
  StringNamesListItem(
      id: "16", name: "chargeable 16 days after contribution date"),
  StringNamesListItem(
      id: "17", name: "chargeable 17 days after contribution date"),
  StringNamesListItem(
      id: "18", name: "chargeable 18 days after contribution date"),
  StringNamesListItem(
      id: "19", name: "chargeable 19 days after contribution date"),
  StringNamesListItem(
      id: "20", name: "chargeable 20 days after contribution date"),
  StringNamesListItem(
      id: "21", name: "chargeable 3 weeks after contribution date"),
  StringNamesListItem(
      id: "22", name: "chargeable 22 days after contribution date"),
  StringNamesListItem(
      id: "23", name: "chargeable 23 days after contribution date"),
  StringNamesListItem(
      id: "24", name: "chargeable 24 days after contribution date"),
  StringNamesListItem(
      id: "25", name: "chargeable 25 days after contribution date"),
  StringNamesListItem(
      id: "26", name: "chargeable 26 days after contribution date"),
  StringNamesListItem(
      id: "27", name: "chargeable 27 days after contribution date"),
  StringNamesListItem(
      id: "28", name: "chargeable 4 weeks after contribution date"),
  StringNamesListItem(
      id: "29", name: "chargeable 29 days after contribution date"),
  StringNamesListItem(
      id: "30", name: "chargeable 30 days after contribution date"),
  StringNamesListItem(
      id: "31", name: "chargeable 31 days after contribution date"),
  StringNamesListItem(
      id: "32", name: "chargeable 32 days after contribution date"),
  StringNamesListItem(
      id: "33", name: "chargeable 33 days after contribution date"),
  StringNamesListItem(
      id: "34", name: "chargeable 34 days after contribution date"),
  StringNamesListItem(
      id: "35", name: "chargeable 5 weeks after contribution date"),
  StringNamesListItem(
      id: "36", name: "chargeable 36 days after contribution date"),
  StringNamesListItem(
      id: "37", name: "chargeable 37 days after contribution date"),
  StringNamesListItem(
      id: "38", name: "chargeable 38 days after contribution date"),
  StringNamesListItem(
      id: "40", name: "chargeable 40 days after contribution date"),
  StringNamesListItem(
      id: "41", name: "chargeable 41 days after contribution date"),
  StringNamesListItem(
      id: "42", name: "chargeable 6 weeks after contribution date"),
  StringNamesListItem(
      id: "43", name: "chargeable 43 days after contribution date"),
  StringNamesListItem(
      id: "44", name: "chargeable 44 days after contribution date"),
  StringNamesListItem(
      id: "45", name: "chargeable 45 days after contribution date"),
  StringNamesListItem(
      id: "46", name: "chargeable 46 days after contribution date"),
  StringNamesListItem(
      id: "47", name: "chargeable 47 days after contribution date"),
  StringNamesListItem(
      id: "48", name: "chargeable 48 days after contribution date"),
  StringNamesListItem(
      id: "49", name: "chargeable 7 weeks after contribution date"),
  StringNamesListItem(
      id: "50", name: "chargeable 50 days after contribution date"),
  StringNamesListItem(
      id: "51", name: "chargeable 51 days after contribution date"),
  StringNamesListItem(
      id: "52", name: "chargeable 52 days after contribution date"),
  StringNamesListItem(
      id: "53", name: "chargeable 53 days after contribution date"),
  StringNamesListItem(
      id: "54", name: "chargeable 54 days after contribution date"),
  StringNamesListItem(
      id: "55", name: "chargeable 55 days after contribution date"),
  StringNamesListItem(
      id: "56", name: "chargeable 8 weeks after contribution date"),
];

List<NamesListItem> percentageFineOnOptions = [
  NamesListItem(id: 1, name: "on contribution amount"),
  NamesListItem(id: 2, name: "on contribution balance"),
  NamesListItem(id: 3, name: "on contribution balance & contribution fines"),
];

List<NamesListItem> fineFrequencyOptions = [
  NamesListItem(id: 0, name: "one time only"),
  NamesListItem(id: 1, name: "per day"),
  NamesListItem(id: 2, name: "per week"),
  NamesListItem(id: 3, name: "per month"),
  NamesListItem(id: 4, name: "per quarter"),
  NamesListItem(id: 5, name: "per half year"),
  NamesListItem(id: 6, name: "per year"),
];

List<NamesListItem> fineLimitOptions = [
  NamesListItem(
      id: 0, name: "do not limit fines generated per unpaid contribution"),
  NamesListItem(id: 1, name: "limit to 1 fine per unpaid contribution"),
  NamesListItem(id: 2, name: "limit to 2 fines per unpaid contribution"),
  NamesListItem(id: 3, name: "limit to 3 fines per unpaid contribution"),
  NamesListItem(id: 4, name: "limit to 4 fines per unpaid contribution"),
  NamesListItem(id: 5, name: "limit to 5 fines per unpaid contribution"),
  NamesListItem(id: 6, name: "limit to 6 fines per unpaid contribution"),
  NamesListItem(id: 7, name: "limit to 7 fines per unpaid contribution"),
  NamesListItem(id: 8, name: "limit to 8 fines per unpaid contribution"),
  NamesListItem(id: 9, name: "limit to 9 fines per unpaid contribution"),
  NamesListItem(id: 10, name: "limit to 10 fines per unpaid contribution"),
  NamesListItem(id: 11, name: "limit to 11 fines per unpaid contribution"),
  NamesListItem(id: 12, name: "limit to 12 fines per unpaid contribution"),
  NamesListItem(id: 13, name: "limit to 13 fines per unpaid contribution"),
  NamesListItem(id: 14, name: "limit to 14 fines per unpaid contribution"),
  NamesListItem(id: 15, name: "limit to 15 fines per unpaid contribution"),
  NamesListItem(id: 16, name: "limit to 16 fines per unpaid contribution"),
  NamesListItem(id: 17, name: "limit to 17 fines per unpaid contribution"),
  NamesListItem(id: 18, name: "limit to 18 fines per unpaid contribution"),
  NamesListItem(id: 19, name: "limit to 19 fines per unpaid contribution"),
  NamesListItem(id: 20, name: "limit to 20 fines per unpaid contribution"),
];
