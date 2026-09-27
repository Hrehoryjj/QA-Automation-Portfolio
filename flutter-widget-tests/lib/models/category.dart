class TransactionCategory {
  final String id;
  final String name;
  final String emoji;

  const TransactionCategory({
    required this.id,
    required this.name,
    required this.emoji,
  });

  TransactionCategory copyWith({String? name, String? emoji}) {
    return TransactionCategory(
      id: id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'emoji': emoji};

  factory TransactionCategory.fromJson(Map<String, dynamic> json) {
    return TransactionCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
    );
  }

  static List<TransactionCategory> get defaults => [
    TransactionCategory(id: 'food',          name: 'Food',          emoji: '🍔'),
    TransactionCategory(id: 'transport',     name: 'Transport',     emoji: '🚗'),
    TransactionCategory(id: 'housing',       name: 'Housing',       emoji: '🏠'),
    TransactionCategory(id: 'health',        name: 'Health',        emoji: '💊'),
    TransactionCategory(id: 'entertainment', name: 'Entertainment', emoji: '🎮'),
    TransactionCategory(id: 'shopping',      name: 'Shopping',      emoji: '🛍️'),
    TransactionCategory(id: 'bills',         name: 'Bills',         emoji: '⚡'),
    TransactionCategory(id: 'other',         name: 'Other',         emoji: '📦'),
  ];
}
