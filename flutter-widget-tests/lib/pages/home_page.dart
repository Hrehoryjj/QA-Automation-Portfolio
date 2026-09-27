import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../models/mock_data.dart';
import '../services/storage_service.dart';
import '../widgets/transaction_components.dart';
import '../widgets/transaction_detail_sheet.dart';
import '../widgets/add_transaction_sheet.dart';
import '../widgets/balance_card.dart';
import '../widgets/search_bar.dart';
import '../utils/emoji_color.dart';
import '../main.dart' show AppColors;
import 'settings_page.dart';
import 'stats_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _filterCategoryId;

  final StorageService _storage = StorageService();
  List<Transaction> _transactions = [];
  List<TransactionCategory> _categories = [];
  double _budget = 5000.0;
  bool _requireConfirmation = true;

  @override
  void initState() { super.initState(); _loadData(); }

  @override
  void dispose() { _searchController.dispose(); super.dispose(); }

  Future<void> _loadData() async {
    final savedTrans  = await _storage.loadTransactions();
    final savedBudget = await _storage.loadBudget();
    final savedConf   = await _storage.loadConfirmSetting();
    final savedCats   = await _storage.loadCategories();
    setState(() {
      _transactions = savedTrans.isEmpty ? MockData.initialTransactions : savedTrans;
      _budget = savedBudget;
      _requireConfirmation = savedConf;
      _categories = savedCats;
      _sortTransactions();
    });
  }

  void _sortTransactions() => _transactions.sort((a, b) => b.date.compareTo(a.date));
  void _saveData() { _storage.saveTransactions(_transactions); _storage.saveBudget(_budget); }
  void _saveCategories(List<TransactionCategory> c) {
    setState(() => _categories = c);
    _storage.saveCategories(c);
  }

  void _addTransaction(String title, double amount, DateTime date,
      {String? note, String? categoryId}) {
    setState(() {
      _transactions.add(Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title, amount: amount, date: date,
        isPlanned: Transaction.checkIsPlanned(date),
        note: note, categoryId: categoryId,
      ));
      _sortTransactions(); _saveData();
    });
  }

  void _deleteTransaction(String id) {
    final idx = _transactions.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    setState(() { _transactions.removeAt(idx); _saveData(); });
  }

  void _updateTransaction(String id, String title, double amount, DateTime date,
      {String? note, bool clearNote = false, String? categoryId, bool clearCategory = false}) {
    setState(() {
      final idx = _transactions.indexWhere((t) => t.id == id);
      if (idx != -1) {
        _transactions[idx] = _transactions[idx].copyWith(
          title: title, amount: amount, date: date,
          note: note, clearNote: clearNote,
          categoryId: categoryId, clearCategory: clearCategory,
        );
        _sortTransactions(); _saveData();
      }
    });
  }

  List<Transaction> get _filtered => _transactions.where((t) {
    final matchSearch   = t.title.toLowerCase().contains(_searchQuery.toLowerCase());
    final matchCategory = _filterCategoryId == null || t.categoryId == _filterCategoryId;
    return matchSearch && matchCategory;
  }).toList();

  @override
  Widget build(BuildContext context) {
    final cs       = Theme.of(context).colorScheme;
    final filtered = _filtered;
    final allSpent = _transactions.where((t) => !t.isPlanned).toList();
    final planned  = filtered.where((t) => t.isPlanned).toList();
    final recent   = filtered.where((t) => !t.isPlanned).toList();

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: cs.surfaceContainerHighest,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 16,
        title: Text('Spendy', style: TextStyle(
          color: cs.onSurface, fontWeight: FontWeight.w800, fontSize: 28,
          letterSpacing: -0.5,
        )),
        actions: [
          _AppBarIcon(
            key: const Key('btn_stats'),
            icon: CupertinoIcons.chart_bar_fill,
            onTap: () => Navigator.push(context, CupertinoPageRoute(
              builder: (_) => StatsPage(
                transactions: _transactions, categories: _categories),
            )),
          ),
          const SizedBox(width: 12),
          _AppBarIcon(
            key: const Key('btn_settings'),
            icon: CupertinoIcons.gear_alt_fill,
            onTap: () async {
              final result = await Navigator.push(context, CupertinoPageRoute(
                builder: (_) => SettingsPage(
                  onClearAll: () => setState(() { _transactions.clear(); _saveData(); }),
                  initialConfirmSetting: _requireConfirmation,
                  categories: _categories,
                  onCategoriesChanged: _saveCategories,
                ),
              ));
              if (result is bool) {
                setState(() => _requireConfirmation = result);
                _storage.saveConfirmSetting(result);
              }
            },
          ),
          const SizedBox(width: 12),
          _AppBarIcon(
            key: const Key('btn_add_transaction'),
            icon: CupertinoIcons.add,
            bold: true,
            onTap: () => _showAddSheet(context),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
        children: [
          BalanceCard(
            totalBalance: _budget - allSpent.fold(0.0, (s, t) => s + t.amount),
            totalBudget: _budget,
            onBalanceChanged: (newBal) => setState(() {
              _budget = newBal + allSpent.fold(0.0, (s, t) => s + t.amount);
              _saveData();
            }),
          ),
          AppSearchBar(
            key: const Key('search_bar'),
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v),
            topPadding: 10,
          ),
          if (_categories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _CategoryFilterRow(
                categories: _categories,
                selectedId: _filterCategoryId,
                onSelected: (id) => setState(() => _filterCategoryId = id),
              ),
            ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.white],
                stops: [0.0, 0.06],
              ).createShader(rect),
              blendMode: BlendMode.dstIn,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  if (planned.isNotEmpty) ...[
                    const _SectionHeader(
                      title: 'PLANNED & OVERDUE', accent: Color(0xFF5E6AD2)),
                    ...planned.map((t) => TransactionTile(
                      transaction: t,
                      requireConfirmation: _requireConfirmation,
                      categories: _categories,
                      onDelete: () => _deleteTransaction(t.id),
                      onTileTap: () => _showTransactionDetails(context, t),
                    )),
                  ],
                  if (recent.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'RECENT HISTORY', accent: cs.onSurfaceVariant),
                    ...recent.map((t) => TransactionTile(
                      key: Key('tile_transaction_${t.id}'),
                      transaction: t,
                      requireConfirmation: _requireConfirmation,
                      categories: _categories,
                      onDelete: () => _deleteTransaction(t.id),
                      onTileTap: () => _showTransactionDetails(context, t),
                    )),
                  ],
                  if (filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(60),
                      child: Center(child: Text('No entries found',
                        style: TextStyle(color: cs.onSurfaceVariant, fontSize: 16))),
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  void _showAddSheet(BuildContext ctx) => showModalBottomSheet(
    context: ctx, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (_) => AddTransactionSheet(categories: _categories, onSave: _addTransaction),
  );

  void _showTransactionDetails(BuildContext ctx, Transaction t) =>
      showModalBottomSheet(
    context: ctx, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (_) => ViewTransactionSheet(
      transaction: t, categories: _categories,
      onUpdate: (title, amount, date,
              {note, clearNote = false, categoryId, clearCategory = false}) =>
          _updateTransaction(t.id, title, amount, date,
            note: note, clearNote: clearNote,
            categoryId: categoryId, clearCategory: clearCategory),
      onDelete: () => _deleteTransaction(t.id),
    ),
  );
}

class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool bold;

  const _AppBarIcon({
    super.key,
    required this.icon, required this.onTap, this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    const gradientColors = [AppColors.cardLightStart, AppColors.cardLightEnd];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (AppColors.cardLightStart)
                  .withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: bold ? 20 : 16,
            weight: bold ? 700 : null),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color accent;
  const _SectionHeader({required this.title, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
      child: Text(title, style: TextStyle(
        color: accent, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0,
      )),
    );
  }
}

class _CategoryFilterRow extends StatelessWidget {
  final List<TransactionCategory> categories;
  final String? selectedId;
  final ValueChanged<String?> onSelected;
  const _CategoryFilterRow({
    required this.categories, required this.selectedId, required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _Chip(key: const Key('chip_all'), label: 'All', emoji: null, isSelected: selectedId == null,
            onTap: () => onSelected(null)),
          const SizedBox(width: 8),
          ...categories.map((c) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _Chip(
              key: Key('chip_cat_${c.id}'),
              label: c.name, emoji: c.emoji,
              isSelected: selectedId == c.id,
              onTap: () => onSelected(selectedId == c.id ? null : c.id),
            ),
          )),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final String? emoji;
  final bool isSelected;
  final VoidCallback onTap;
  const _Chip({
    super.key,
    required this.label, required this.emoji,
    required this.isSelected, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final gradStart = AppColors.cardLightStart;
    const gradEnd   = AppColors.cardLightEnd;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: EdgeInsets.fromLTRB(emoji != null ? 5 : 14, 6, 14, 6),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [gradStart, gradEnd],
                  begin: Alignment.topLeft, end: Alignment.bottomRight)
              : null,
          color: isSelected ? null : cs.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.transparent : cs.outlineVariant,
            width: 1.0,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: gradStart.withValues(alpha: 0.35),
                  blurRadius: 8, offset: const Offset(0, 3))]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (emoji != null) ...[
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: EmojiColor.backgroundFor(emoji!, dark: false),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(emoji!, style: const TextStyle(fontSize: 15)),
              ),
            ),
            const SizedBox(width: 7),
          ],
          Text(label, style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : cs.onSurface,
          )),
        ]),
      ),
    );
  }
}
