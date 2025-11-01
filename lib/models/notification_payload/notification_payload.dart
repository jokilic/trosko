import 'dart:convert';

class NotificationPayload {
  final String? name;
  final int? amountCents;
  final DateTime? createdAt;

  NotificationPayload({
    required this.name,
    required this.amountCents,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    'name': name,
    'amountCents': amountCents,
    'createdAt': createdAt?.millisecondsSinceEpoch,
  };

  factory NotificationPayload.fromMap(Map<String, dynamic> map) => NotificationPayload(
    name: map['name'] != null ? map['name'] as String : null,
    amountCents: map['amountCents'] != null ? map['amountCents'] as int : null,
    createdAt: map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int) : null,
  );

  String toJson() => json.encode(toMap());

  factory NotificationPayload.fromJson(String source) => NotificationPayload.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NotificationPayload(name: $name, amountCents: $amountCents, createdAt: $createdAt)';

  @override
  bool operator ==(covariant NotificationPayload other) {
    if (identical(this, other)) {
      return true;
    }

    return other.name == name && other.amountCents == amountCents && other.createdAt == createdAt;
  }

  @override
  int get hashCode => name.hashCode ^ amountCents.hashCode ^ createdAt.hashCode;
}
