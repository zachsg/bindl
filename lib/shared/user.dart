import 'package:bindl/shared/tags.dart';
import 'package:flutter/material.dart';

class User {
  final String name;
  final List<Tag> likeTags;
  final List<Tag> dislikeTags;

  User({required this.name, required this.likeTags, required this.dislikeTags});
}
