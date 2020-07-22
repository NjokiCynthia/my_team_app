import 'package:flutter/material.dart';

class ValidateSettings {
  bool validate(
      {@required int contributionType, int selectedFrequency, int daysOfTheMonth, int weekDayWeekly, int weekNumberFortnight, int startingMonth}) {
    print("Selected Frequency: $selectedFrequency");
    print("Selected daysOfTheMonth: $daysOfTheMonth");
    print("Selected weekDayWeekly: $weekDayWeekly");
    print("Selected weekNumberFortnight: $weekNumberFortnight");
    print("Selected startMonthMultiple: $startingMonth");

    bool isValid = true;
    if (contributionType == null) {
      isValid = false;
    } else {
      if (selectedFrequency == null) {
        isValid = false;
      } else {
        if (selectedFrequency == 1) {
          if (daysOfTheMonth == null) {
            //monthly
            isValid = false;
          }
        } else if (selectedFrequency == 6) {
          //weekly
          if (weekDayWeekly == null) {
            isValid = false;
          }
        } else if (selectedFrequency == 7) {
          //fortnightly
          if (weekDayWeekly == null) {
            isValid = false;
          }
          if (weekNumberFortnight == null) {
            isValid = false;
          }
        } else if (selectedFrequency == 2) {
          //bimonthly
          if (daysOfTheMonth == null) {
            return false;
          }
          if (startingMonth == null) isValid = false;
        } else if (selectedFrequency == 3) {
          //quarterly
          if (daysOfTheMonth == null) {
            isValid = false;
          }
          if (startingMonth == null) isValid = false;
        } else if (selectedFrequency == 4) {
          //biannually
          if (daysOfTheMonth == null) {
            isValid = false;
          }
          if (startingMonth == null) isValid = false;
        } else if (selectedFrequency == 5) {
          //annually
          if (daysOfTheMonth == null) {
            isValid = false;
          }
          if (startingMonth == null) isValid = false;
        }
      }
    }
    return isValid;
  }
}
