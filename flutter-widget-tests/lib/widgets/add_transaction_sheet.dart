import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../models/category.dart';
import '../utils/date_formatter.dart';
import '../main.dart' show AppColors;
import 'category_chips.dart';

class AddTransactionSheet extends StatefulWidget {
  final List<TransactionCategory> categories;
  final Function(String, double, DateTime, {String? note, String? categoryId}) onSave;

  const AddTransactionSheet({super.key, required this.onSave, required this.categories});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategoryId;

  @override
  void dispose() {
    _titleCtrl.dispose(); _amountCtrl.dispose(); _noteCtrl.dispose();
    super.dispose();
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        final cs = Theme.of(context).colorScheme;
        return Container(
          height: 250,
          color: cs.surface,
          child: Column(children: [
            Container(
              color: cs.surfaceContainerHighest,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                CupertinoButton(
                  child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.pop(context),
                ),
              ]),
            ),
            Expanded(child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _selectedDate,
              onDateTimeChanged: (d) => setState(() => _selectedDate = d),
            )),
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fieldBg = cs.surfaceContainerHighest;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(color: cs.outlineVariant, borderRadius: BorderRadius.circular(2)),
          )),
          Text('New Transaction', style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: cs.onSurface)),
          const SizedBox(height: 20),
          _field(CupertinoTextField(
            key: const Key('input_tx_title'),
            controller: _titleCtrl, placeholder: 'What for?',
            padding: const EdgeInsets.all(16), autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(color: cs.onSurface),
            placeholderStyle: TextStyle(color: cs.onSurfaceVariant),
            decoration: BoxDecoration(color: fieldBg, borderRadius: BorderRadius.circular(12)),
          )),
          const SizedBox(height: 12),
          _field(CupertinoTextField(
            key: const Key('input_tx_amount'),
            controller: _amountCtrl, placeholder: '0.00',
            prefix: Padding(padding: const EdgeInsets.only(left: 16),
              child: Text('\$', style: TextStyle(color: cs.onSurfaceVariant))),
            padding: const EdgeInsets.all(16),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(color: cs.onSurface),
            placeholderStyle: TextStyle(color: cs.onSurfaceVariant),
            decoration: BoxDecoration(color: fieldBg, borderRadius: BorderRadius.circular(12)),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          )),
          const SizedBox(height: 12),
          GestureDetector(
            key: const Key('btn_tx_date'),
            onTap: _showDatePicker,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: fieldBg, borderRadius: BorderRadius.circular(12)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Date', style: TextStyle(fontSize: 16, color: cs.onSurface)),
                Row(children: [
                  Text(DateFormatter.format(_selectedDate),
                    style: const TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.w600)),
                  Icon(CupertinoIcons.chevron_right, size: 16, color: cs.onSurfaceVariant),
                ]),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          _field(CupertinoTextField(
            key: const Key('input_tx_note'),
            controller: _noteCtrl, placeholder: 'Add a note (optional)',
            padding: const EdgeInsets.all(16), maxLines: 3, minLines: 1,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(color: cs.onSurface),
            placeholderStyle: TextStyle(color: cs.onSurfaceVariant),
            decoration: BoxDecoration(color: fieldBg, borderRadius: BorderRadius.circular(12)),
          )),
          if (widget.categories.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Category', style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: cs.onSurfaceVariant)),
            const SizedBox(height: 8),
            CategoryChips(
              categories: widget.categories,
              selectedId: _selectedCategoryId,
              onSelected: (id) => setState(() => _selectedCategoryId = id),
            ),
          ],
          const SizedBox(height: 32),
          Builder(builder: (ctx) {
            final grad   = [AppColors.cardLightStart, AppColors.cardLightEnd];
            return GestureDetector(
              key: const Key('btn_save_transaction'),
              onTap: () {
                final amount = double.tryParse(_amountCtrl.text);
                if (_titleCtrl.text.isNotEmpty && amount != null && amount > 0) {
                  final note = _noteCtrl.text.trim();
                  widget.onSave(_titleCtrl.text, amount, _selectedDate,
                    note: note.isNotEmpty ? note : null, categoryId: _selectedCategoryId);
                  Navigator.pop(context);
                } else {
                  HapticFeedback.vibrate();
                }
              },
              child: Container(
                width: double.infinity, height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: grad,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (AppColors.cardLightStart)
                          .withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text('Save Transaction',
                  style: TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _field(Widget child) => child;
}
