class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isPlanned;
  final String? note;
  final String? categoryId;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.isPlanned = false,
    this.note,
    this.categoryId,
  });

  static bool checkIsPlanned(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date.isAfter(
      today.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1)),
    );
  }

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    bool? isPlanned,
    String? note,
    bool clearNote = false,
    String? categoryId,
    bool clearCategory = false,
  }) {
    final newDate = date ?? this.date;
    final newIsPlanned = date != null
        ? checkIsPlanned(newDate)
        : (isPlanned ?? this.isPlanned);
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: newDate,
      isPlanned: newIsPlanned,
      note: clearNote ? null : (note ?? this.note),
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'isPlanned': isPlanned,
      'date': date.toIso8601String(),
      if (note != null) 'note': note,
      if (categoryId != null) 'categoryId': categoryId,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final date = json['date'] != null
        ? DateTime.parse(json['date'] as String)
        : DateTime.now();
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: date,
      isPlanned: checkIsPlanned(date),
      note: json['note'] as String?,
      categoryId: json['categoryId'] as String?,
    );
  }
}
