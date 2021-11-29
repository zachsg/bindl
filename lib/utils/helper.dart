import 'package:bindl/shared/allergy.dart';
import 'package:bindl/shared/tag.dart';

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
