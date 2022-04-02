import 'models/ingredient_measure.dart';

extension StringExtension on String {
  String toDate() {
    final parsedDate = DateTime.parse(this);

    return '${parsedDate.month}/${parsedDate.day}/${parsedDate.year}';
  }

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

  String toMonth() {
    switch (this) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return DateTime.now().month.toString();
    }
  }

  String toWeekday() {
    switch (this) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'n/a';
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

  double toGramsFrom(IngredientMeasure measure) {
    switch (measure) {
      case IngredientMeasure.tbsp:
        return this * 12.5;
      case IngredientMeasure.tsp:
        return this * 4.2;
      case IngredientMeasure.lb:
        return this * 453.592;
      case IngredientMeasure.oz:
        return this * 28.35;
      case IngredientMeasure.cup:
        return this * 128.0;
      case IngredientMeasure.g:
        return this;
      case IngredientMeasure.mg:
        return this * 1000.0;
      case IngredientMeasure.pinch:
        return this * 0.355625;
      case IngredientMeasure.ingredient:
        // TODO: Dunno?
        break;
      case IngredientMeasure.toTaste:
        // TODO: Dunno?
        break;
      default:
        return this;
    }

    return this;
  }

  double fromGramsTo(IngredientMeasure measure) {
    switch (measure) {
      case IngredientMeasure.tbsp:
        return this / 12.5;
      case IngredientMeasure.tsp:
        return this / 4.2;
      case IngredientMeasure.lb:
        return this / 453.592;
      case IngredientMeasure.oz:
        return this / 28.35;
      case IngredientMeasure.cup:
        return this / 128.0;
      case IngredientMeasure.g:
        return this;
      case IngredientMeasure.mg:
        return this / 1000.0;
      case IngredientMeasure.pinch:
        return this / 0.355625;
      case IngredientMeasure.ingredient:
        // TODO: Dunno?
        break;
      case IngredientMeasure.toTaste:
        // TODO: Dunno?
        break;
      default:
        return this;
    }

    return this;
  }
}
