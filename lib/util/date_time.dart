bool isSameMonth(DateTime a, DateTime b) => a.year == b.year && a.month == b.month;

DateTime toYmd(DateTime d) => DateTime(d.year, d.month, d.day);
