import 'transaction.dart';

class MockData {
  static List<Transaction> get initialTransactions {
    final now   = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final planned = [
      Transaction(
        id: 'mock_1',
        title: 'Groceries',
        amount: 150.0,
        isPlanned: true,
        date: today.add(const Duration(days: 7)),
        categoryId: 'food',
      ),
      Transaction(
        id: 'mock_2',
        title: 'Internet Bill',
        amount: 60.0,
        isPlanned: true,
        date: today.add(const Duration(days: 5)),
        categoryId: 'bills',
      ),
      Transaction(
        id: 'mock_3',
        title: 'Gym Membership',
        amount: 35.0,
        isPlanned: true,
        date: today.add(const Duration(days: 12)),
        categoryId: 'health',
      ),
    ];

    final overdue = [
      Transaction(
        id: 'mock_4',
        title: 'Rent',
        amount: 1200.0,
        isPlanned: true,
        date: today.subtract(const Duration(days: 2)),
        categoryId: 'housing',
      ),
    ];

    final completedToday = [
      Transaction(
        id: 'mock_5',
        title: 'Coffee',
        amount: 5.50,
        isPlanned: false,
        date: today,
        categoryId: 'food',
      ),
      Transaction(
        id: 'mock_6',
        title: 'Bus ticket',
        amount: 2.80,
        isPlanned: false,
        date: today,
        categoryId: 'transport',
      ),
    ];

    final completedRecent = [
      Transaction(
        id: 'mock_7',
        title: 'Electricity Bill',
        amount: 75.0,
        isPlanned: false,
        date: today.subtract(const Duration(days: 1)),
        categoryId: 'bills',
        note: 'Paid via app',
      ),
      Transaction(
        id: 'mock_8',
        title: 'Dinner Out',
        amount: 60.0,
        isPlanned: false,
        date: today.subtract(const Duration(days: 3)),
        categoryId: 'food',
      ),
      Transaction(
        id: 'mock_9',
        title: 'Gas',
        amount: 45.0,
        isPlanned: false,
        date: today.subtract(const Duration(days: 4)),
        categoryId: 'transport',
      ),
      Transaction(
        id: 'mock_10',
        title: 'Netflix',
        amount: 15.99,
        isPlanned: false,
        date: today.subtract(const Duration(days: 6)),
        categoryId: 'entertainment',
      ),
      Transaction(
        id: 'mock_11',
        title: 'Pharmacy',
        amount: 22.50,
        isPlanned: false,
        date: today.subtract(const Duration(days: 8)),
        categoryId: 'health',
        note: 'Vitamins + painkillers',
      ),
      Transaction(
        id: 'mock_12',
        title: 'T-shirt',
        amount: 29.99,
        isPlanned: false,
        date: today.subtract(const Duration(days: 10)),
        categoryId: 'shopping',
      ),
    ];

    return [...planned, ...overdue, ...completedToday, ...completedRecent];
  }
}
