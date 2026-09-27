class DateFormatter {
  static String format(DateTime date) {
    final now = DateTime.now();
    final d = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    if (d.isAtSameMomentAs(today)) return 'Today';
    if (d.isAtSameMomentAs(yesterday)) return 'Yesterday';
    if (d.isAtSameMomentAs(tomorrow)) return 'Tomorrow';

    return '${date.day.toString().padLeft(2, '0')}'
        '.${date.month.toString().padLeft(2, '0')}'
        '.${date.year}';
  }
}
