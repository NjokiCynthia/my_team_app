import 'package:flutter/cupertino.dart';

class FormField {
  final String id;

  FormField(this.id);
}

class DepositReconciliation with ChangeNotifier {
  List<FormField> formFields = [FormField(DateTime.now().toString())];

  List<Map> formData = [];

  // add Form fields
  void addFormFields(data, id) {
    formData.add({"$id": data});
    formFields.add(FormField(DateTime.now().toString()));
    notifyListeners();
  }

  // remove form fields.
  void removeFormFields(id) {
    formFields.removeWhere((field) => field.id == id);
    formData.removeWhere((data) => data.containsKey(id));
    notifyListeners();
  }

  // get the total amount entered.
  double getTotalAmount() {
    double total = 0.0;

    // ensure that formData has data.
    if (formData.length > 0) {
      // loop through the data.
      for (var entity in formData) {
        entity.values.forEach((value) {
          if (value['amount'] != null) {
            total += value['amount'];
          }
        });
      }

      return total;
    } else {
      return total;
    }
  }

  // reset
  void reset() {
    formFields = [FormField(DateTime.now().toString())];
    formData = [];
    notifyListeners();
  }
}
