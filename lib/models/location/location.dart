import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';

@HiveType(typeId: 13)
class Location {
  @HiveField(1)
  final String id;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String? address;

  @HiveField(4)
  final double latitude;

  @HiveField(5)
  final double longitude;

  @HiveField(6)
  final DateTime createdAt;

  Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.address,
  });

  factory Location.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Location.fromMap(data);
  }

  factory Location.fromMap(Map<String, dynamic> map) => Location(
    id: map['id'] as String,
    name: map['name'] as String,
    address: map['address'] as String?,
    latitude: (map['latitude'] as num).toDouble(),
    longitude: (map['longitude'] as num).toDouble(),
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'name': name,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  @override
  String toString() => 'Location(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, createdAt: $createdAt)';

  @override
  bool operator ==(covariant Location other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id && other.name == name && other.address == address && other.latitude == latitude && other.longitude == longitude && other.createdAt == createdAt;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ address.hashCode ^ latitude.hashCode ^ longitude.hashCode ^ createdAt.hashCode;
}
