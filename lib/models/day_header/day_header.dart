class DayHeader {
  final String label;
  final int amountCents;
  final DateTime day;

  const DayHeader({
    required this.label,
    required this.amountCents,
    required this.day,
  });

  @override
  String toString() => 'DayHeader(label: $label, amountCents: $amountCents, day: $day)';

  @override
  bool operator ==(covariant DayHeader other) {
    if (identical(this, other)) {
      return true;
    }

    return other.label == label && other.amountCents == amountCents && other.day == day;
  }

  @override
  int get hashCode => label.hashCode ^ amountCents.hashCode ^ day.hashCode;
}
