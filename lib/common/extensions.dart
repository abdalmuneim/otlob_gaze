import 'package:intl/intl.dart';
import 'package:otlob_gas/common/utils.dart';

extension DoubleExtensions on double {
  String get toPrice {
    return '${this} ${Utils.localization?.currency ?? ''}';
  }
}

extension IntExtensions on int {
  String get getDurationReminder {
    if (toString().length == 1) {
      return '0$this';
    } else {
      return '$this';
    }
  }
}

extension DateTimeExtensions on DateTime? {
  String get appDateFormat {
    if (this == null) {
      return '';
    }
    if (Utils.localization?.localeName == 'ar') {
      return DateFormat('MMM ,d,y', 'ar').format(this!);
    } else {
      return DateFormat('MMM ,y,d', 'en').format(this!);
    }
  }
}
