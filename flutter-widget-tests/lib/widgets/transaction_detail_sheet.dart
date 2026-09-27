import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../utils/date_formatter.dart';
import '../utils/emoji_color.dart';
import '../main.dart' show AppColors;
import 'category_chips.dart';
import 'delete_confirm_dialog.dart';

class ViewTransactionSheet extends StatefulWidget {
  final Transaction transaction;
  final List<TransactionCategory> categories;
  final Function(String title, double amount, DateTime date,
      {String? note, bool clearNote, String? categoryId, bool clearCategory}) onUpdate;
  final VoidCallback onDelete;

  const ViewTransactionSheet({
    super.key,
    required this.transaction,
    required this.categories,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<ViewTransactionSheet> createState() => _ViewTransactionSheetState();
}

class _ViewTransactionSheetState extends State<ViewTransactionSheet> {
  bool _isEditing = false;
  late TextEditingController _titleCtrl, _amountCtrl, _noteCtrl;
  late DateTime _selectedDate;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _titleCtrl  = TextEditingController(text: widget.transaction.title);
    _amountCtrl = TextEditingController(
        text: widget.transaction.amount.toStringAsFixed(2));
    _noteCtrl   = TextEditingController(text: widget.transaction.note ?? '');
    _selectedDate       = widget.transaction.date;
    _selectedCategoryId = widget.transaction.categoryId;
  }

  @override
  void dispose() {
    _titleCtrl.dispose(); _amountCtrl.dispose(); _noteCtrl.dispose();
    super.dispose();
  }

  bool get _editIsPlanned => Transaction.checkIsPlanned(_selectedDate);

  TransactionCategory? _catById(String? id) => id == null
      ? null : widget.categories.where((c) => c.id == id).firstOrNull;

  void _markDone() {
    final today = DateTime.now();
    widget.onUpdate(
      widget.transaction.title,
      widget.transaction.amount,
      today,
      note: widget.transaction.note,
      categoryId: widget.transaction.categoryId,
    );
    Navigator.pop(context);
  }

  void _pickDate(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    DateTime tempDate = _selectedDate;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: 320,
        color: cs.surface,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 0),
            child: Row(children: [
              Text('Date', style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: cs.onSurface)),
              const Spacer(),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() => _selectedDate = tempDate);
                  Navigator.pop(context);
                },
                child: const Text('Done',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _selectedDate,
              onDateTimeChanged: (dt) => tempDate = dt,
            ),
          ),
        ]),
      ),
    );
  }

  void _save() {
    final noteText = _noteCtrl.text.trim();
    final title    = _titleCtrl.text.trim();
    widget.onUpdate(
      title.isEmpty ? widget.transaction.title : title,
      double.tryParse(_amountCtrl.text) ?? widget.transaction.amount,
      _selectedDate,
      note: noteText.isNotEmpty ? noteText : null,
      clearNote: noteText.isEmpty,
      categoryId: _selectedCategoryId,
      clearCategory: _selectedCategoryId == null,
    );
    Navigator.pop(context);
  }

  void _confirmDelete(BuildContext context) {
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
        message: 'Remove "${widget.transaction.title}"? This cannot be undone.',
        onConfirm: () {
          Navigator.pop(ctx);
          Navigator.pop(context);
          widget.onDelete();
        },
        onCancel: () => Navigator.pop(ctx),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final fieldBg = cs.surfaceContainerHighest;

    final now     = DateTime.now();
    final today   = DateTime(now.year, now.month, now.day);
    final txDay   = DateTime(widget.transaction.date.year,
        widget.transaction.date.month, widget.transaction.date.day);
    final isOverdue  = widget.transaction.isPlanned && txDay.isBefore(today);
    final isPlanned  = widget.transaction.isPlanned;
    final hasNote    = widget.transaction.note?.isNotEmpty == true;
    final viewCat    = _catById(widget.transaction.categoryId);
    final btnGrad = [AppColors.cardLightStart, AppColors.cardLightEnd];

    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 12, 24, MediaQuery.of(context).viewInsets.bottom + 28),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: cs.outlineVariant, borderRadius: BorderRadius.circular(2)),
          ),

          if (!_isEditing) ...[

            Row(children: [
              if (isPlanned)
                _MarkDoneButton(key: const Key('btn_mark_done'), isOverdue: isOverdue, onTap: _markDone)
              else
                const SizedBox.shrink(),
              const Spacer(),
              GestureDetector(
                key: const Key('btn_delete_transaction'),
                onTap: () => _confirmDelete(context),
                child: Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B30).withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(CupertinoIcons.delete,
                    color: Color(0xFFFF3B30), size: 16),
                ),
              ),
            ]),

            const SizedBox(height: 16),

            if (viewCat != null)
              Container(
                width: 60, height: 60,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: EmojiColor.backgroundFor(viewCat.emoji),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(child: Text(viewCat.emoji,
                  style: const TextStyle(fontSize: 30))),
              ),

            Text(widget.transaction.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                color: cs.onSurface)),
            const SizedBox(height: 6),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(DateFormatter.format(widget.transaction.date).toUpperCase(),
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 11,
                  fontWeight: FontWeight.bold, letterSpacing: 1.0)),
              if (isPlanned || isOverdue) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(width: 3, height: 3,
                    decoration: BoxDecoration(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                      shape: BoxShape.circle)),
                ),
                Text(isOverdue ? 'OVERDUE' : 'PLANNED',
                  style: TextStyle(
                    color: isOverdue
                        ? const Color(0xFFFF3B30)
                        : const Color(0xFF5E6AD2),
                    fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
              ],
            ]),

            const SizedBox(height: 10),

            Text('\$${widget.transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 38, fontWeight: FontWeight.w900, letterSpacing: -1,
                color: isOverdue
                    ? const Color(0xFFFF3B30)
                    : isPlanned ? const Color(0xFF5E6AD2) : cs.onSurface,
              )),

            if (viewCat != null) ...[
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(CupertinoIcons.tag, size: 13, color: cs.onSurfaceVariant),
                const SizedBox(width: 5),
                Text(viewCat.name, style: TextStyle(
                  fontSize: 13, color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500)),
              ]),
            ],

            if (hasNote) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: fieldBg, borderRadius: BorderRadius.circular(12)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(CupertinoIcons.text_alignleft,
                    size: 15, color: cs.onSurfaceVariant),
                  const SizedBox(width: 10),
                  Expanded(child: Text(widget.transaction.note!,
                    style: TextStyle(fontSize: 14, color: cs.onSurface,
                      height: 1.4))),
                ]),
              ),
            ],

            const SizedBox(height: 28),

            _ActionButton(
              key: const Key('btn_edit_transaction'),
              label: 'Edit transaction',
              gradient: btnGrad, textColor: Colors.white,
              onTap: () => setState(() => _isEditing = true),
            ),
            const SizedBox(height: 10),
            _ActionButton(
              key: const Key('btn_cancel'),
              label: 'Cancel',
              gradient: null, color: fieldBg,
              textColor: cs.onSurfaceVariant,
              onTap: () => Navigator.pop(context),
            ),

          ] else ...[
            CupertinoTextField(
              key: const Key('input_edit_title'),
              controller: _titleCtrl, placeholder: 'Title',
              padding: const EdgeInsets.all(16),
              style: TextStyle(color: cs.onSurface),
              placeholderStyle: TextStyle(color: cs.onSurfaceVariant),
              decoration: BoxDecoration(
                color: fieldBg, borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 12),

            CupertinoTextField(
              key: const Key('input_edit_amount'),
              controller: _amountCtrl, placeholder: 'Amount',
              keyboardType: TextInputType.number,
              padding: const EdgeInsets.all(16),
              style: TextStyle(color: cs.onSurface),
              placeholderStyle: TextStyle(color: cs.onSurfaceVariant),
              decoration: BoxDecoration(
                color: fieldBg, borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 12),

            GestureDetector(
              key: const Key('btn_edit_date'),
              onTap: () => _pickDate(context),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  color: fieldBg, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Icon(CupertinoIcons.calendar,
                    size: 17, color: cs.onSurfaceVariant),
                  const SizedBox(width: 10),
                  Expanded(child: Text(DateFormatter.format(_selectedDate),
                    style: TextStyle(fontSize: 15, color: cs.onSurface))),
                  _InlineBadge(isPlanned: _editIsPlanned),
                  const SizedBox(width: 4),
                  Icon(CupertinoIcons.chevron_right,
                    size: 14, color: cs.onSurfaceVariant),
                ]),
              ),
            ),
            const SizedBox(height: 12),

            CupertinoTextField(
              key: const Key('input_edit_note'),
              controller: _noteCtrl,
              placeholder: 'Add a note (optional)',
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
              maxLines: 3, minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: cs.onSurface),
              placeholderStyle: TextStyle(color: cs.onSurfaceVariant),
              decoration: BoxDecoration(
                color: fieldBg, borderRadius: BorderRadius.circular(12)),
              suffix: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _noteCtrl,
                builder: (_, val, __) {
                  if (val.text.isEmpty) return const SizedBox.shrink();
                  return CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minSize: 0,
                    onPressed: () => _noteCtrl.clear(),
                    child: const Icon(CupertinoIcons.xmark_circle_fill,
                      size: 18, color: CupertinoColors.systemGrey),
                  );
                },
              ),
            ),

            if (widget.categories.isNotEmpty) ...[
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerLeft,
                child: Text('Category', style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600,
                  color: cs.onSurfaceVariant))),
              const SizedBox(height: 8),
              CategoryChips(
                key: const Key('category_chips_edit'),
                categories: widget.categories,
                selectedId: _selectedCategoryId,
                onSelected: (id) => setState(() => _selectedCategoryId = id),
                scrollable: false,
              ),
            ],

            const SizedBox(height: 28),

            _ActionButton(
              key: const Key('btn_save_changes'),
              label: 'Save changes',
              gradient: btnGrad, textColor: Colors.white,
              onTap: _save,
            ),
          ],

        ],
      ),
    );
  }
}

class _MarkDoneButton extends StatelessWidget {
  final bool isOverdue;
  final VoidCallback onTap;
  const _MarkDoneButton({super.key, required this.isOverdue, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = isOverdue ? const Color(0xFFFF3B30) : const Color(0xFF5E6AD2);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(CupertinoIcons.checkmark_circle, color: color, size: 14),
          const SizedBox(width: 5),
          Text('Mark as done', style: TextStyle(
            color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

class _InlineBadge extends StatelessWidget {
  final bool isPlanned;
  const _InlineBadge({required this.isPlanned});

  @override
  Widget build(BuildContext context) {
    final color = isPlanned ? const Color(0xFF5E6AD2) : const Color(0xFF34C759);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(isPlanned ? 'Planned' : 'Completed',
        style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final List<Color>? gradient;
  final Color? color;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionButton({
    super.key,
    required this.label,
    required this.gradient,
    this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: gradient != null
              ? LinearGradient(colors: gradient!,
                  begin: Alignment.topLeft, end: Alignment.bottomRight)
              : null,
          color: gradient == null ? color : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(label, style: TextStyle(
          color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
