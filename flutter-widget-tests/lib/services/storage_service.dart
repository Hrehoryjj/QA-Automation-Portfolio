import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/category.dart';

class StorageService {
  static const String _transactionsKey = 'transactions';
  static const String _budgetKey = 'budget';
  static const String _confirmKey = 'require_confirm';
  static const String _categoriesKey = 'categories';
  Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      transactions.map((t) => t.toJson()).toList(),
    );
    await prefs.setString(_transactionsKey, encoded);
  }

  Future<List<Transaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_transactionsKey);
    if (encoded != null) {
      final List<dynamic> decoded = jsonDecode(encoded);
      return decoded.map((json) => Transaction.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveBudget(double budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_budgetKey, budget);
  }

  Future<double> loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_budgetKey) ?? 5000.0;
  }

  Future<void> saveConfirmSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_confirmKey, value);
  }

  Future<bool> loadConfirmSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_confirmKey) ?? true;
  }

  Future<void> saveCategories(List<TransactionCategory> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(categories.map((c) => c.toJson()).toList());
    await prefs.setString(_categoriesKey, encoded);
  }

  Future<List<TransactionCategory>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_categoriesKey);
    if (encoded != null) {
      final List<dynamic> decoded = jsonDecode(encoded);
      return decoded
          .map((j) => TransactionCategory.fromJson(j as Map<String, dynamic>))
          .toList();
    }
    return TransactionCategory.defaults;
  }
}
