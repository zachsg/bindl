import 'package:bodai/models/xmodels.dart';

class Helpers {
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

  static bool isInteger(num value) =>
      value is int || value == value.roundToDouble();

  static bool isIngredientQuantity(String text) {
    if (text.toLowerCase() == 'f' ||
        text.toLowerCase() == 'degrees' ||
        text.toLowerCase() == 'c' ||
        text.toLowerCase() == 'celsius' ||
        text.toLowerCase() == 'fahrenheit' ||
        text.toLowerCase() == 'times' ||
        text.toLowerCase() == 'min' ||
        text.toLowerCase().contains('minute') ||
        text.toLowerCase() == 'hr' ||
        text.toLowerCase().contains('hour') ||
        text.toLowerCase() == 'sec' ||
        text.toLowerCase().contains('second')) {
      return false;
    } else if (text.contains('teaspoon') ||
        text.toLowerCase().contains('tsp') ||
        text.toLowerCase().contains('cup') ||
        text.toLowerCase() == 'c' ||
        text.toLowerCase().contains('tablespoon') ||
        text.toLowerCase().contains('tbsp') ||
        text.toLowerCase().contains('pound') ||
        text.toLowerCase().contains('lb') ||
        text.toLowerCase().contains('ounce') ||
        text.toLowerCase().contains('oz') ||
        text.toLowerCase().contains('gram') ||
        text.toLowerCase().contains('slice') ||
        text.toLowerCase().contains('patties') ||
        text.toLowerCase().contains('portion') ||
        text.toLowerCase() == 'g') {
      return true;
    }

    return false;
  }

  static bool isFraction(String text) {
    var startsWithDigit = text.startsWith('0') ||
        text.startsWith('1') ||
        text.startsWith('2') ||
        text.startsWith('3') ||
        text.startsWith('4') ||
        text.startsWith('5') ||
        text.startsWith('6') ||
        text.startsWith('7') ||
        text.startsWith('8') ||
        text.startsWith('9');

    var endsWithDigit = text.endsWith('0') ||
        text.endsWith('1') ||
        text.endsWith('2') ||
        text.endsWith('3') ||
        text.endsWith('4') ||
        text.endsWith('5') ||
        text.endsWith('6') ||
        text.endsWith('7') ||
        text.endsWith('8') ||
        text.endsWith('9');

    if (startsWithDigit && text.contains('/') && endsWithDigit) {
      return true;
    } else {
      return false;
    }
  }

  static bool isNumber(String text) {
    if (isFraction(text)) {
      return true;
    } else if (double.tryParse(text) != null) {
      return true;
    } else {
      return false;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  double toDouble() {
    var parsedDouble = double.tryParse(this);

    if (parsedDouble != null) {
      // Easily parsed to double
      return parsedDouble;
    }

    switch (this) {
      case '1/10':
        return 0.1;
      case '1/5':
        return 0.2;
      case '1/4':
        return 0.25;
      case '1/3':
        return 0.33;
      case '2/5':
        return 0.4;
      case '1/2':
        return 0.5;
      case '3/5':
        return 0.6;
      case '2/3':
        return 0.67;
      case '3/4':
        return 0.75;
      case '4/5':
        return 0.8;
      case '7/8':
        return 0.88;
      default:
        return 0.0;
    }
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
        if (decimalFirstPass > 100) {
          var textNum = decimalFirstPass.toString();
          var digitOne = int.parse(textNum[0]);
          var digitTwo = int.parse(textNum[1]);
          decimal = int.parse('$digitOne$digitTwo');
        } else {
          decimal = decimalFirstPass;
        }
      } else {
        decimal = decimalFirstPass * 10;
      }

      if (first == 0) {
        return decimal.toFraction().contains('.')
            ? '$first${decimal.toFraction()}'
            : decimal.toFraction();
      } else {
        if (decimal == 0) {
          return '$first';
        } else {
          return decimal.toFraction().contains('.')
              ? '$first${decimal.toFraction()}'
              : '$first ${decimal.toFraction()}';
        }
      }
    } else {
      return toString();
    }
  }
}

extension IntExtension on int {
  String toFraction() {
    if (this >= 8 && this <= 15) {
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
    } else if (this >= 64 && this <= 71) {
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

extension ListFromMap<Key, Element> on Map<Key, Element> {
  List<T> toList<T>(T Function(MapEntry<Key, Element> entry) getElement) =>
      entries.map(getElement).toList();
}

extension CapExtension on String {
  String capitalizeWords() {
    return split(' ').map((str) => str.capitalize()).join(' ');
  }
}
