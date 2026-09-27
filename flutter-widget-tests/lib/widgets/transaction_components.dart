import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../utils/date_formatter.dart';
import '../utils/emoji_color.dart';
import 'delete_confirm_dialog.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTileTap;
  final VoidCallback onDelete;
  final bool requireConfirmation;
  final List<TransactionCategory> categories;

  const TransactionTile({
    super.key, required this.transaction, this.onTileTap,
    required this.onDelete, required this.requireConfirmation, required this.categories,
  });

  TransactionCategory? get _category => transaction.categoryId == null
      ? null : categories.where((c) => c.id == transaction.categoryId).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now    = DateTime.now();
    final today  = DateTime(now.year, now.month, now.day);
    final isOverdue = transaction.isPlanned &&
        DateTime(transaction.date.year, transaction.date.month, transaction.date.day).isBefore(today);
    final cat      = _category;
    final subtitle = cat != null
        ? '${DateFormatter.format(transaction.date)} · ${cat.name}'
        : DateFormatter.format(transaction.date);

    final leadingBg = isOverdue
        ? const Color(0xFFFF3B30).withValues(alpha: 0.10)
        : cat != null
            ? EmojiColor.backgroundFor(cat.emoji, dark: isDark)
            : cs.surfaceContainerHighest;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Slidable(
          key: Key(transaction.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.22,
            children: [
              CustomSlidableAction(
                onPressed: (ctx) => _handleDelete(ctx),
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                child: Container(
                  color: const Color(0xFFFF3B30),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.delete, color: Colors.white, size: 20),
                      SizedBox(height: 3),
                      Text('Delete', style: TextStyle(
                        color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: cs.surface,
              border: isOverdue
                  ? const Border(left: BorderSide(color: Color(0xFFFF3B30), width: 3))
                  : transaction.isPlanned
                      ? const Border(left: BorderSide(color: Color(0xFF5E6AD2), width: 3))
                      : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: ListTile(
                onTap: onTileTap,
                contentPadding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
                leading: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: leadingBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: cat != null
                        ? Text(cat.emoji, style: const TextStyle(fontSize: 19))
                        : Icon(
                            isOverdue
                                ? CupertinoIcons.exclamationmark_triangle_fill
                                : CupertinoIcons.creditcard,
                            size: 19,
                            color: isOverdue ? const Color(0xFFFF3B30) : cs.onSurfaceVariant,
                          ),
                  ),
                ),
                title: Text(transaction.title, style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 15, color: cs.onSurface)),
                subtitle: Text(subtitle, style: TextStyle(
                  color: isOverdue ? const Color(0xFFFF3B30) : cs.onSurfaceVariant,
                  fontSize: 12, fontWeight: FontWeight.w400,
                )),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${transaction.isPlanned ? "" : "−"}\$${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isOverdue
                            ? const Color(0xFFFF3B30)
                            : transaction.isPlanned ? const Color(0xFF5E6AD2) : cs.onSurface,
                        fontWeight: FontWeight.w700, fontSize: 15,
                      ),
                    ),
                    if (transaction.isPlanned)
                      Text(isOverdue ? 'Overdue' : 'Planned', style: TextStyle(
                        color: isOverdue ? const Color(0xFFFF3B30) : const Color(0xFF5E6AD2),
                        fontSize: 11, fontWeight: FontWeight.w500,
                      )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context) {
    if (requireConfirmation) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true, barrierLabel: '',
        barrierColor: Colors.black.withValues(alpha: 0.45),
        transitionDuration: const Duration(milliseconds: 220),
        transitionBuilder: (_, anim, __, child) => ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim, child: child),
        ),
        pageBuilder: (ctx, _, __) => DeleteConfirmDialog(
          title: 'Delete transaction?',
          message: 'Remove "${transaction.title}"? This cannot be undone.',
          onConfirm: () { Navigator.pop(ctx); onDelete(); },
          onCancel: () => Navigator.pop(ctx),
        ),
      );
    } else {
      onDelete();
    }
  }
}
