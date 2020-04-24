import 'package:chamasoft/screens/chamasoft/models/named-list-item.dart';

List<NamesListItem> contributionTypeOptions = [
  NamesListItem(id: 1, name: "Regular Contribution"),
  NamesListItem(id: 2, name: "One Time Contribution"),
  NamesListItem(id: 3, name: "Non Scheduled Contribution")
];

List<NamesListItem> getMonths = [
  NamesListItem(id: 1, name: "January"),
  NamesListItem(id: 2, name: "February"),
  NamesListItem(id: 3, name: "March"),
  NamesListItem(id: 4, name: "April"),
  NamesListItem(id: 5, name: "May"),
  NamesListItem(id: 6, name: "June"),
  NamesListItem(id: 7, name: "July"),
  NamesListItem(id: 8, name: "August"),
  NamesListItem(id: 9, name: "September"),
  NamesListItem(id: 10, name: "October"),
  NamesListItem(id: 11, name: "November"),
  NamesListItem(id: 12, name: "December"),
];

//start_month_multiple

List<NamesListItem> getStartingMonths = [
  NamesListItem(id: 1, name: "starting in January"),
  NamesListItem(id: 2, name: "starting in February"),
  NamesListItem(id: 3, name: "starting in March"),
  NamesListItem(id: 4, name: "starting in April"),
  NamesListItem(id: 5, name: "starting in May"),
  NamesListItem(id: 6, name: "starting in June"),
  NamesListItem(id: 7, name: "starting in July"),
  NamesListItem(id: 8, name: "starting in August"),
  NamesListItem(id: 9, name: "starting in September"),
  NamesListItem(id: 10, name: "starting in October"),
  NamesListItem(id: 11, name: "starting in November"),
  NamesListItem(id: 12, name: "starting in December"),
];

List<NamesListItem> getInvoiceDays = [
  NamesListItem(id: 1, name: "1 day before Contribution date"),
  NamesListItem(id: 2, name: "2 days before Contribution date"),
  NamesListItem(id: 3, name: "3 days before Contribution date"),
  NamesListItem(id: 4, name: "4 days before Contribution date"),
  NamesListItem(id: 5, name: "5 days before Contribution date"),
  NamesListItem(id: 6, name: "6 days before Contribution date"),
  NamesListItem(id: 7, name: "1 week before Contribution date"),
  NamesListItem(id: 8, name: "8 days before Contribution date"),
  NamesListItem(id: 9, name: "9 days before Contribution date"),
  NamesListItem(id: 10, name: "10 days before Contribution date"),
  NamesListItem(id: 11, name: "11 days before Contribution date"),
  NamesListItem(id: 12, name: "12 days before Contribution date"),
  NamesListItem(id: 13, name: "13 days before Contribution date"),
  NamesListItem(id: 14, name: "2 Weeks before Contribution date"),
];

//week_number_fortnight
List<NamesListItem> getWeekNumbers = [
  NamesListItem(id: 1, name: "of the First Week"),
  NamesListItem(id: 2, name: "of the Second Week"),
];

//week_day_fortnight
List<NamesListItem> getEveryTwoWeekDays = [
  NamesListItem(id: 1, name: "Every Sunday"),
  NamesListItem(id: 2, name: "Every Monday"),
  NamesListItem(id: 3, name: "Every Tuesday"),
  NamesListItem(id: 4, name: "Every Wednesday"),
  NamesListItem(id: 5, name: "Every Thursday"),
  NamesListItem(id: 6, name: "Every Friday"),
  NamesListItem(id: 7, name: "Every Saturday"),
];

//week_day_weekly
List<NamesListItem> getWeekDays = [
  NamesListItem(id: 1, name: "Every Sunday of the Week"),
  NamesListItem(id: 2, name: "Every Monday of the Week"),
  NamesListItem(id: 3, name: "Every Tuesday of the Week"),
  NamesListItem(id: 4, name: "Every Wednesday of the Week"),
  NamesListItem(id: 5, name: "Every Thursday of the Week"),
  NamesListItem(id: 6, name: "Every Friday of the Week"),
  NamesListItem(id: 7, name: "Every Saturday of the Week"),
];

//week_day_monthly
List<NamesListItem> getMonthDays = [
  NamesListItem(id: 0, name: "Day of the Month"),
  NamesListItem(id: 1, name: "Sunday of the Month"),
  NamesListItem(id: 2, name: "Monday of the Month"),
  NamesListItem(id: 3, name: "Tuesday of the Month"),
  NamesListItem(id: 4, name: "Wednesday of the Month"),
  NamesListItem(id: 5, name: "Thursday of the Month"),
  NamesListItem(id: 6, name: "Friday of the Month"),
  NamesListItem(id: 7, name: "Saturday of the Month"),
];

//month_day_monthly week_day_multiple month day multiple
List<NamesListItem> getDaysOfTheMonth = [
  NamesListItem(id: 1, name: "Every 1st"),
  NamesListItem(id: 2, name: "Every 2nd"),
  NamesListItem(id: 3, name: "Every 3rd"),
  NamesListItem(id: 4, name: "Every 4th"),
  NamesListItem(id: 32, name: "Every Last"),
  NamesListItem(id: 5, name: "Every 5th"),
  NamesListItem(id: 6, name: "Every 6th"),
  NamesListItem(id: 7, name: "Every 7th"),
  NamesListItem(id: 8, name: "Every 8th"),
  NamesListItem(id: 9, name: "Every 9th"),
  NamesListItem(id: 10, name: "Every 10th"),
  NamesListItem(id: 11, name: "Every 11th"),
  NamesListItem(id: 12, name: "Every 12th"),
  NamesListItem(id: 13, name: "Every 13th"),
  NamesListItem(id: 14, name: "Every 14th"),
  NamesListItem(id: 15, name: "Every 15th"),
  NamesListItem(id: 16, name: "Every 16th"),
  NamesListItem(id: 17, name: "Every 17th"),
  NamesListItem(id: 18, name: "Every 18th"),
  NamesListItem(id: 19, name: "Every 19th"),
  NamesListItem(id: 20, name: "Every 20th"),
  NamesListItem(id: 21, name: "Every 21st"),
  NamesListItem(id: 22, name: "Every 22nd"),
  NamesListItem(id: 23, name: "Every 22rd"),
  NamesListItem(id: 24, name: "Every 24th"),
  NamesListItem(id: 25, name: "Every 25th"),
  NamesListItem(id: 26, name: "Every 26th"),
  NamesListItem(id: 27, name: "Every 27th"),
  NamesListItem(id: 28, name: "Every 28th"),
  NamesListItem(id: 29, name: "Every 29th"),
  NamesListItem(id: 30, name: "Every 30th"),
  NamesListItem(id: 31, name: "Every 31st"),
];

//month_day_monthly , name:week_day_multiple, name:month day multiple
List<NamesListItem> getDaysOfTheMonthAfterOption = [
  NamesListItem(id: 1, name: "After 1st"),
  NamesListItem(id: 2, name: "After 2nd"),
  NamesListItem(id: 3, name: "After 3rd"),
  NamesListItem(id: 4, name: "After 4th"),
  NamesListItem(id: 5, name: "After 5th"),
  NamesListItem(id: 6, name: "After 6th"),
  NamesListItem(id: 7, name: "After 7th"),
  NamesListItem(id: 8, name: "After 8th"),
  NamesListItem(id: 9, name: "After 9th"),
  NamesListItem(id: 10, name: "After 10th"),
  NamesListItem(id: 11, name: "After 11th"),
  NamesListItem(id: 12, name: "After 12th"),
  NamesListItem(id: 13, name: "After 13th"),
  NamesListItem(id: 14, name: "After 14th"),
  NamesListItem(id: 15, name: "After 15th"),
  NamesListItem(id: 16, name: "After 16th"),
  NamesListItem(id: 17, name: "After 17th"),
  NamesListItem(id: 18, name: "After 18th"),
  NamesListItem(id: 19, name: "After 19th"),
  NamesListItem(id: 20, name: "After 20th"),
  NamesListItem(id: 21, name: "After 21st"),
  NamesListItem(id: 22, name: "After 22nd"),
  NamesListItem(id: 23, name: "After 22rd"),
  NamesListItem(id: 24, name: "After 24th"),
  NamesListItem(id: 25, name: "After 25th"),
  NamesListItem(id: 26, name: "After 26th"),
  NamesListItem(id: 27, name: "After 27th"),
  NamesListItem(id: 28, name: "After 28th"),
  NamesListItem(id: 29, name: "After 29th"),
  NamesListItem(id: 30, name: "After 30th"),
];

List<NamesListItem> getContributionFrequencyOptions = [
  NamesListItem(id: 1, name: "Once a Month (Monthly)"),
  NamesListItem(id: 6, name: "Once a Week (Weekly)"),
  NamesListItem(id: 8, name: "Once a Day (Daily)"),
  NamesListItem(id: 7, name: "Once Every Two Weeks (Fortnightly)"),
  NamesListItem(id: 2, name: "Once Every Two Months (Bimonthly)"),
  NamesListItem(id: 3, name: "Once Every Three Months (Quarterly)"),
  NamesListItem(id: 4, name: "Once Every Six Months (Biannually)"),
  NamesListItem(id: 5, name: "Once a Year (Annually)"),
  NamesListItem(id: 9, name: "Twice Every Month(After A Date)"),
];
