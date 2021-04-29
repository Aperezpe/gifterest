import 'package:age/age.dart';

extension AgeCalculator on DateTime {
  int getAge(DateTime dob) {
    AgeDuration age = Age.dateDifference(
        fromDate: dob, toDate: DateTime.now(), includeToDate: false);

    return age.years;
  }
}
