import 'package:intl/intl.dart';

extension ExDateTime on DateTime {
  String format() {
    final format = DateFormat('yyyy-MM-dd');
    return format.format(this);
  }
}
