import 'package:hive_ce/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(1)
  final String id;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final int amountCents;

  @HiveField(4)
  final String categoryId;

  @HiveField(5)
  final String? note;

  @HiveField(6)
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.name,
    required this.amountCents,
    required this.categoryId,
    required this.createdAt,
    this.note,
  });

  @override
  String toString() => 'Transaction(id: $id, name: $name, amountCents: $amountCents, categoryId: $categoryId, note: $note, createdAt: $createdAt)';

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id && other.name == name && other.amountCents == amountCents && other.categoryId == categoryId && other.note == note && other.createdAt == createdAt;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ amountCents.hashCode ^ categoryId.hashCode ^ note.hashCode ^ createdAt.hashCode;
}
