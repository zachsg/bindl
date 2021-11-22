import 'package:bindl/shared/tags.dart';
import 'package:bindl/shared/user.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  final user = User(name: '', likeTags: [], dislikeTags: []);

  void addTags(List<Tag> tags, bool isLike) {
    for (var tag in tags) {
      if (isLike) {
        if (!user.likeTags.contains(tag)) {
          user.likeTags.add(tag);
        }
      } else {
        if (!user.dislikeTags.contains(tag)) {
          user.dislikeTags.add(tag);
        }
      }
    }
  }
}
