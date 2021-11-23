import 'package:bindl/shared/tags.dart';
import 'package:flutter/material.dart';

class User {
  final String name;
  final Map<Tag, int> tags;

  User({required this.name, required this.tags});
}

class UserController extends ChangeNotifier {
  final user = User(name: '', tags: {});

  void addTags(List<Tag> tags, bool isLike) {
    for (var tag in tags) {
      if (isLike) {
        if (user.tags.containsKey(tag)) {
          user.tags[tag] = user.tags[tag]! + 1;
        } else {
          user.tags[tag] = 1;
        }
      } else {
        if (user.tags.containsKey(tag)) {
          user.tags[tag] = user.tags[tag]! - 1;
        } else {
          user.tags[tag] = -1;
        }
      }
    }

    notifyListeners();
  }

  List<MapEntry<Tag, int>> sortedTags() {
    return user.tags.entries.toList()
      ..sort((e1, e2) {
        var diff = e2.value.compareTo(e1.value);
        return diff;
      });
  }
}
