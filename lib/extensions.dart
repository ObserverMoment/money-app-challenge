import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension BuildContextExtension on BuildContext {
  dynamic pop({dynamic result, bool rootNavigator = false}) =>
      Navigator.of(this, rootNavigator: rootNavigator).pop(result);
}

extension DateTimeExtension on DateTime {
  DateTime oneDayBefore({int hourOffset = 0}) =>
      DateTime(year, month, day - 1, hour + hourOffset);

  DateTime offsetHours(int hourOffset) =>
      DateTime(year, month, day, hour + hourOffset);

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  String get daysAgoOrDateDisplay => isToday
      ? 'Today'
      : isYesterday
          ? 'Yesterday'
          : dayDateMonth;

  String get dayDateMonth => DateFormat('E dd MMM').format(this);
}

extension DoubleExtension on double {
  String stringMyDouble({int decimalPlaces = 2}) {
    final int i = truncate();
    if (this == i) {
      return i.toStringAsFixed(decimalPlaces);
    }
    // Returns to max of two decimal places
    return ((this * pow(10, decimalPlaces)).round() / pow(10, decimalPlaces))
        .toStringAsFixed(decimalPlaces);
  }
}

extension IterableDoubleExtension on Iterable<double> {
  double get sum => reduce((value, element) => value + element);
}
