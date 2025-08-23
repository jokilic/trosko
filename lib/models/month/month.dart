class Month {
  final DateTime date;
  final String label;

  Month({
    required this.date,
    required this.label,
  });

  Month copyWith({
    DateTime? date,
    String? label,
  }) => Month(
    date: date ?? this.date,
    label: label ?? this.label,
  );

  @override
  String toString() => 'Month(date: $date, label: $label)';

  @override
  bool operator ==(covariant Month other) {
    if (identical(this, other)) {
      return true;
    }

    return other.date == date && other.label == label;
  }

  @override
  int get hashCode => date.hashCode ^ label.hashCode;
}
