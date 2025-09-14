class Month {
  final DateTime date;
  final String label;

  Month({
    required this.date,
    required this.label,
  });

  factory Month.all() => Month(
    date: DateTime.fromMillisecondsSinceEpoch(0),
    label: 'All',
  );

  bool get isAll => date.millisecondsSinceEpoch == 0;

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
