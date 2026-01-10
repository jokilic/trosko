class AITransaction {
  final String id;
  final String? name;
  final int? amountCents;
  final String? categoryId;
  final String? note;
  final DateTime? createdAt;
  final String? locationId;

  AITransaction({
    required this.id,
    this.name,
    this.amountCents,
    this.categoryId,
    this.createdAt,
    this.note,
    this.locationId,
  });

  factory AITransaction.fromMap(Map<String, dynamic> map) => AITransaction(
    id: map['id'] as String,
    name: map['name'] != null ? map['name'] as String : null,
    amountCents: map['amountCents'] != null ? map['amountCents'] as int : null,
    categoryId: map['categoryId'] != null ? map['categoryId'] as String : null,
    note: map['note'] != null ? map['note'] as String : null,
    createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt'] as String) : null,
    locationId: map['locationId'] != null ? map['locationId'] as String : null,
  );

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'name': name,
    'amountCents': amountCents,
    'categoryId': categoryId,
    'note': note,
    'createdAt': createdAt?.toIso8601String(),
    'locationId': locationId,
  };

  @override
  String toString() => 'AITransaction(id: $id, name: $name, amountCents: $amountCents, categoryId: $categoryId, note: $note, createdAt: $createdAt, locationId: $locationId)';

  @override
  bool operator ==(covariant AITransaction other) {
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
