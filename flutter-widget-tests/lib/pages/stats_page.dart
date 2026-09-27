import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/category.dart';

enum StatPeriod { week, month, allTime }

extension StatPeriodLabel on StatPeriod {
  String get label {
    switch (this) {
      case StatPeriod.week: return 'This Week';
      case StatPeriod.month: return 'This Month';
      case StatPeriod.allTime: return 'All Time';
    }
  }
}

class StatsPage extends StatefulWidget {
  final List<Transaction> transactions;
  final List<TransactionCategory> categories;

  const StatsPage({super.key, required this.transactions, required this.categories});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  StatPeriod _period = StatPeriod.month;

  List<Transaction> get _filtered {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return widget.transactions.where((t) {
      switch (_period) {
        case StatPeriod.week:
          final weekStart = today.subtract(Duration(days: today.weekday - 1));
          return !t.date.isBefore(weekStart);
        case StatPeriod.month:
          return t.date.year == now.year && t.date.month == now.month;
        case StatPeriod.allTime:
          return true;
      }
    }).toList();
  }

  List<Transaction> get _completed => _filtered.where((t) => !t.isPlanned).toList();
  List<Transaction> get _planned => _filtered.where((t) => t.isPlanned).toList();

  double get _totalSpent => _completed.fold(0.0, (s, t) => s + t.amount);
  double get _totalPlanned => _planned.fold(0.0, (s, t) => s + t.amount);

  List<_CategoryStat> get _categoryStats {
    final total = _totalSpent;
    if (total == 0) return [];
    final Map<String?, double> map = {};
    for (final t in _completed) {
      map[t.categoryId] = (map[t.categoryId] ?? 0) + t.amount;
    }
    return map.entries.map((e) {
      final cat = e.key == null ? null
          : widget.categories.where((c) => c.id == e.key).firstOrNull;
      return _CategoryStat(
        label: cat?.name ?? 'Uncategorized',
        emoji: cat?.emoji ?? '📋',
        amount: e.value,
        fraction: e.value / total,
      );
    }).toList()..sort((a, b) => b.amount.compareTo(a.amount));
  }

  List<Transaction> get _top3 {
    final sorted = List<Transaction>.from(_completed)
      ..sort((a, b) => b.amount.compareTo(a.amount));
    return sorted.take(3).toList();
  }

  String _fmt(double v) => v >= 1000 ? '\$${(v / 1000).toStringAsFixed(1)}k' : '\$${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final stats = _categoryStats;
    final top3 = _top3;
    final hasData = _filtered.isNotEmpty;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: cs.surfaceContainerHighest,
        elevation: 0, surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: cs.onSurface),
        title: Text('Statistics', style: TextStyle(
          color: cs.onSurface, fontWeight: FontWeight.w900, fontSize: 28)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
        children: [
          const SizedBox(height: 8),
          _PeriodSelector(
            selected: _period,
            onChanged: (p) => setState(() => _period = p),
          ),
          const SizedBox(height: 20),

          if (!hasData) ...[
            _EmptyState(period: _period),
          ] else ...[
            _SectionLabel(label: 'OVERVIEW', cs: cs),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _SummaryCard(
                title: 'Completed', count: _completed.length, amount: _totalSpent,
                color: cs.onSurface, icon: CupertinoIcons.checkmark_circle_fill, cs: cs,
              )),
              const SizedBox(width: 12),
              Expanded(child: _SummaryCard(
                title: 'Planned', count: _planned.length, amount: _totalPlanned,
                color: const Color(0xFF5E6AD2), icon: CupertinoIcons.clock_fill, cs: cs,
              )),
            ]),
            const SizedBox(height: 24),

            if (stats.isNotEmpty) ...[
              _SectionLabel(label: 'BY CATEGORY', cs: cs),
              const SizedBox(height: 14),
              _CategoryBarChart(stats: stats, cs: cs),
              const SizedBox(height: 24),
            ],

            if (top3.isNotEmpty) ...[
              _SectionLabel(label: 'TOP EXPENSES', cs: cs),
              const SizedBox(height: 10),
              ...top3.asMap().entries.map((e) {
                final t = e.value;
                final cat = t.categoryId == null ? null
                    : widget.categories.where((c) => c.id == t.categoryId).firstOrNull;
                return _TopTransactionTile(
                  rank: e.key + 1, transaction: t, category: cat,
                  formattedAmount: _fmt(t.amount), cs: cs,
                );
              }),
            ],
          ],
        ],
      ),
    );
  }
}

class _CategoryStat {
  final String label, emoji;
  final double amount, fraction;
  const _CategoryStat({required this.label, required this.emoji, required this.amount, required this.fraction});
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final ColorScheme cs;
  const _SectionLabel({required this.label, required this.cs});

  @override
  Widget build(BuildContext context) => Text(label, style: TextStyle(
    color: cs.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2));
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final double amount;
  final Color color;
  final IconData icon;
  final ColorScheme cs;

  const _SummaryCard({required this.title, required this.count, required this.amount,
    required this.color, required this.icon, required this.cs});

  String _fmt(double v) => v >= 1000 ? '\$${(v / 1000).toStringAsFixed(1)}k' : '\$${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ]),
        const SizedBox(height: 10),
        Text(_fmt(amount), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: cs.onSurface)),
        const SizedBox(height: 2),
        Text('$count transaction${count == 1 ? '' : 's'}',
          style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
      ]),
    );
  }
}

class _CategoryBarChart extends StatefulWidget {
  final List<_CategoryStat> stats;
  final ColorScheme cs;
  const _CategoryBarChart({required this.stats, required this.cs});

  @override
  State<_CategoryBarChart> createState() => _CategoryBarChartState();
}

class _CategoryBarChartState extends State<_CategoryBarChart> with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _progress = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() { _anim.dispose(); super.dispose(); }

  String _fmt(double v) => v >= 1000 ? '\$${(v / 1000).toStringAsFixed(1)}k' : '\$${v.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final cs = widget.cs;
    const palette = [const Color(0xFF1c1c1e), const Color(0xFF636366), const Color(0xFF48484A),
           const Color(0xFF8E8E93), const Color(0xFFAEAEB2), const Color(0xFFD1D1D6)];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(18)),
      child: AnimatedBuilder(
        animation: _progress,
        builder: (_, __) => Column(
          children: widget.stats.asMap().entries.map((e) {
            final i = e.key; final stat = e.value;
            final color = palette[i % palette.length];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(stat.emoji, style: const TextStyle(fontSize: 15)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(stat.label,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: cs.onSurface),
                    overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 8),
                  Text(_fmt(stat.amount),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: cs.onSurface)),
                  const SizedBox(width: 6),
                  SizedBox(width: 36, child: Text(
                    '${(stat.fraction * 100).toStringAsFixed(0)}%',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant))),
                ]),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(height: 7, child: Stack(children: [
                    Container(color: cs.surfaceContainerHighest),
                    FractionallySizedBox(
                      widthFactor: stat.fraction * _progress.value,
                      child: Container(decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(4))),
                    ),
                  ])),
                ),
              ]),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TopTransactionTile extends StatelessWidget {
  final int rank;
  final Transaction transaction;
  final TransactionCategory? category;
  final String formattedAmount;
  final ColorScheme cs;

  const _TopTransactionTile({required this.rank, required this.transaction,
    required this.category, required this.formattedAmount, required this.cs});

  @override
  Widget build(BuildContext context) {
    final medalColors = [const Color(0xFFFFD700), const Color(0xFFC0C0C0), const Color(0xFFCD7F32)];
    final medalColor = medalColors[rank - 1];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(color: medalColor.withValues(alpha: 0.15), shape: BoxShape.circle),
          child: Center(child: Text('$rank', style: TextStyle(
            color: medalColor, fontWeight: FontWeight.w900, fontSize: 13))),
        ),
        const SizedBox(width: 12),
        if (category != null) ...[
          Text(category!.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
        ],
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(transaction.title, style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface),
            overflow: TextOverflow.ellipsis),
          if (category != null)
            Text(category!.name, style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
        ])),
        Text(formattedAmount, style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w900, color: cs.onSurface)),
      ]),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final StatPeriod period;
  const _EmptyState({required this.period});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final label = period == StatPeriod.week ? 'this week'
        : period == StatPeriod.month ? 'this month' : 'yet';
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Center(child: Column(children: [
        const Text('📊', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 16),
        Text('No transactions $label', style: TextStyle(
          fontSize: 15, color: cs.onSurfaceVariant, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Text('Add some transactions to see your stats.',
          style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant.withValues(alpha: 0.6))),
      ])),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final StatPeriod selected;
  final ValueChanged<StatPeriod> onChanged;
  const _PeriodSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: StatPeriod.values.map((p) {
          final isSelected = p == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: isSelected ? cs.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected ? [BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6, offset: const Offset(0, 2))] : [],
                ),
                alignment: Alignment.center,
                child: Text(p.label, style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? cs.onSurface : cs.onSurfaceVariant,
                )),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
