import 'package:intl/intl.dart';

/// Calculates age from birth date string
int? calculateAge(String? birthDateString) {
  if (birthDateString == null || birthDateString.isEmpty) {
    return null;
  }

  try {
    final birthDate = DateTime.parse(birthDateString);
    final today = DateTime.now();

    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age < 0 ? 0 : age;
  } catch (e) {
    print("Error parsing birth date: $e");
    return null;
  }
}

/// Formats date to readable string
String formatDate(DateTime date, {String format = 'dd MMM yyyy'}) {
  return DateFormat(format).format(date);
}
