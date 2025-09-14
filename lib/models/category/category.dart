import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category {
  @HiveField(1)
  final String id;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.color,
  });

  @override
  String toString() => 'Category(id: $id, name: $name, color: $color)';

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id && other.name == name && other.color == color;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ color.hashCode;
}
