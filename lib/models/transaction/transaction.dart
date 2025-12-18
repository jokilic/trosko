import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';

@HiveType(typeId: 11)
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

  @HiveField(7)
  final String? locationId;

  Transaction({
    required this.id,
    required this.name,
    required this.amountCents,
    required this.categoryId,
    required this.createdAt,
    this.note,
    this.locationId,
  });

  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Transaction.fromMap(data);
  }

  factory Transaction.fromMap(Map<String, dynamic> map) => Transaction(
    id: map['id'] as String,
    name: map['name'] as String,
    amountCents: map['amountCents'] as int,
    categoryId: map['categoryId'] as String,
    note: map['note'] != null ? map['note'] as String : null,
    createdAt: (map['createdAt'] as Timestamp).toDate(),
    locationId: map['locationId'] as String?,
  );

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'name': name,
    'amountCents': amountCents,
    'categoryId': categoryId,
    'note': note,
    'createdAt': Timestamp.fromDate(createdAt),
    'locationId': locationId,
  };

  @override
  String toString() => 'Transaction(id: $id, name: $name, amountCents: $amountCents, categoryId: $categoryId, note: $note, createdAt: $createdAt, locationId: $locationId)';

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.name == name &&
        other.amountCents == amountCents &&
        other.categoryId == categoryId &&
        other.note == note &&
        other.createdAt == createdAt &&
        other.locationId == locationId;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ amountCents.hashCode ^ categoryId.hashCode ^ note.hashCode ^ createdAt.hashCode ^ locationId.hashCode;
}
