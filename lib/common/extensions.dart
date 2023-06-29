import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../l10n/app_localizations.dart';

// extension ParseToString on FilterMapEntryKey {
//   String toShortString() {
//     return this.toString().split('.').last.toLowerCase();
//   }
// }

extension StringX on String {
  Color hexToColor() =>
      Color(int.parse(substring(1, 7), radix: 16) + 0xFF000000);

  int toInt() => int.parse(this);

  Uri toUri() => Uri.parse(this);

  String toShortString() {
    return split('.').last.toLowerCase();
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  DateTime fromTimeStamp() {
    return DateTime.fromMillisecondsSinceEpoch(toInt() * 1000);
  }

  String get normalize {
    String decodedUrl = Uri.decodeFull(this);
    return path.normalize(decodedUrl);
    // return path.normalize(this);
  }
}

extension IntX on num {
  String toStringAndFill({int length = 2, String value = '0'}) => toString().padLeft(length, value);
}

extension DoubleX on double {
  double truncateToDecimals(int decimals) =>
      double.parse(toStringAsFixed(decimals));
}

extension DurationX on Duration {
  String toTimeFormattedString() {
    String twoDigitSeconds = inSeconds.remainder(60).toStringAndFill();
    String twoDigitMinutes = '${inMinutes.remainder(60).toStringAndFill()}:';
    String twoDigitHours = inHours == 0 ? '' : '${inHours.toStringAndFill()}:';

    String finalStr = '$twoDigitHours$twoDigitMinutes$twoDigitSeconds';
    return finalStr;
  }
}

extension ColorX on Color {
  String get toHex {
    return '#${value.toRadixString(16).substring(2)}';
  }
}

extension DateTimeX on DateTime {
  int get toTimeStamp => millisecondsSinceEpoch ~/ 1000;
}


extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  bool get isTablet {
    final screenWidth = MediaQuery.of(this).size.width;
    return screenWidth >= 600;
  }

  String translate(String key, {String param = ''}) {
    return AppLocalizations.of(this)!.translate(key, param: param);
  }
}