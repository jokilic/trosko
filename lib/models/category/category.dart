import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Category {
  final String id;

  final String name;

  final Color color;

  final String iconName;

  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.iconName,
    required this.createdAt,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Category.fromMap(data);
  }

  factory Category.fromMap(Map<String, dynamic> map) => Category(
    id: map['id'] as String,
    name: map['name'] as String,
    color: Color((map['color'] as num).toInt()),
    iconName: map['iconName'] as String,
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'name': name,
    'color': color.toARGB32(),
    'iconName': iconName,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  @override
  String toString() => 'Category(id: $id, name: $name, color: $color, iconName: $iconName, createdAt: $createdAt)';

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id && other.name == name && other.color == color && other.iconName == iconName && other.createdAt == createdAt;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ color.hashCode ^ iconName.hashCode ^ createdAt.hashCode;
}
