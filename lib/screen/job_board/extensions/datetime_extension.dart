import 'package:intl/intl.dart' as formatter;

const String _defaultDateFormat = "dd.MM.yyyy";

extension DateTimeExtensions on DateTime? {
  String get dateString => this != null ? formatter.DateFormat(_defaultDateFormat).format(this!) : "-";
}
