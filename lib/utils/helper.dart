import 'package:bindl/meal_plan/ingredient.dart';
import 'package:bindl/shared/allergy.dart';
import 'package:bindl/shared/providers.dart';
import 'package:bindl/shared/tag.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Helper {
  static Map<String, dynamic> allergyMapToJson(Map<Allergy, bool> map) {
    Map<String, dynamic> json = {};

    map.forEach((key, value) {
      json[key.index.toString()] = value;
    });

    return json;
  }

  static Map<Allergy, bool> allergyJsonToMap(Map<String, dynamic> json) {
    Map<Allergy, bool> map = {};

    json.forEach((key, value) {
      map[Allergy.values.elementAt(int.parse(key))] = value as bool;
    });

    return map;
  }

  static Map<String, dynamic> tagsMapToJson(Map<Tag, int> map) {
    Map<String, dynamic> json = {};

    map.forEach((key, value) {
      json[key.index.toString()] = value;
    });

    return json;
  }

  static Map<Tag, int> tagsJsonToMap(Map<String, dynamic> json) {
    Map<Tag, int> map = {};

    json.forEach((key, value) {
      map[Tag.values.elementAt(int.parse(key))] = value as int;
    });

    return map;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension DoubleExtension on double {
  String toFractionString() {
    var splitted = toString().split('.');

    if (splitted.length == 2) {
      var first = double.parse(splitted.first).toInt();
      var decimalFirstPass = double.parse(splitted.last).toInt();
      var decimal = 0;
      if (decimalFirstPass > 10) {
        decimal = decimalFirstPass;
      } else {
        decimal = decimalFirstPass * 10;
      }

      if (first == 0) {
        return decimal.toFraction().contains('.')
            ? '$first${decimal.toFraction()}'
            : decimal.toFraction();
      } else {
        return decimal.toFraction().contains('.')
            ? '$first${decimal.toFraction()}'
            : '$first ${decimal.toFraction()}';
      }
    } else {
      return toString();
    }
  }
}

extension IntExtension on int {
  String toFraction() {
    if (this >= 10 && this <= 15) {
      return '1/10';
    } else if (this >= 16 && this <= 22) {
      return '1/5';
    } else if (this >= 23 && this <= 29) {
      return '1/4';
    } else if (this >= 30 && this <= 36) {
      return '1/3';
    } else if (this >= 37 && this <= 43) {
      return '2/5';
    } else if (this >= 44 && this <= 55) {
      return '1/2';
    } else if (this >= 56 && this <= 63) {
      return '3/5';
    } else if (this >= 64 && this < 71) {
      return '2/3';
    } else if (this >= 72 && this <= 77) {
      return '3/4';
    } else if (this >= 78 && this <= 83) {
      return '4/5';
    } else if (this >= 84 && this <= 93) {
      return '7/8';
    } else {
      return '.$this';
    }
  }
}

bool isInteger(num value) => value is int || value == value.roundToDouble();
