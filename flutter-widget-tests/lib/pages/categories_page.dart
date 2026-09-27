import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/category.dart';
import '../utils/emoji_color.dart';
import '../widgets/delete_confirm_dialog.dart';
import '../main.dart' show AppColors;

class CategoriesPage extends StatefulWidget {
  final List<TransactionCategory> categories;
  final ValueChanged<List<TransactionCategory>> onChanged;

  const CategoriesPage({super.key, required this.categories, required this.onChanged});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late List<TransactionCategory> _categories;

  @override
  void initState() { super.initState(); _categories = List.from(widget.categories); }

  void _push() => widget.onChanged(_categories);

  void _deleteCategory(int index) {
    showGeneralDialog(
      context: context, barrierDismissible: true, barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      pageBuilder: (ctx, _, __) => DeleteConfirmDialog(
        title: 'Delete category?',
        message: 'Transactions with "${_categories[index].name}" will become uncategorized.',
        onConfirm: () {
          Navigator.pop(ctx);
          Navigator.pop(context);
          setState(() => _categories.removeAt(index));
          _push();
        },
        onCancel: () => Navigator.pop(ctx),
      ),
    );
  }

  void _showEditSheet({TransactionCategory? existing, int? index}) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => _CategoryEditSheet(
        initial: existing,
        onSave: (cat) {
          setState(() {
            if (index != null) _categories[index] = cat; else _categories.add(cat);
          });
          _push();
        },
        onDelete: index != null ? () => _deleteCategory(index) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      appBar: AppBar(
        title: Text('Categories',
          style: TextStyle(fontWeight: FontWeight.bold, color: cs.onSurface)),
        backgroundColor: cs.surfaceContainerHighest,
        elevation: 0, surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: cs.onSurface),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(key: const Key('btn_add_category'), icon: const Icon(Icons.add), onPressed: () => _showEditSheet())],
      ),
      body: _categories.isEmpty
          ? Center(child: Text('No categories yet.\nTap + to add one.',
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 15)))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 2),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final isFirst = i == 0;
                final isLast  = i == _categories.length - 1;
                final radius  = BorderRadius.vertical(
                  top:    Radius.circular(isFirst ? 16 : 4),
                  bottom: Radius.circular(isLast  ? 16 : 4),
                );
                return GestureDetector(
                  key: Key('btn_cat_\${cat.id}'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _showEditSheet(existing: cat, index: i),
                  child: Container(
                    decoration: BoxDecoration(color: cs.surface, borderRadius: radius),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: EmojiColor.backgroundFor(cat.emoji),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(cat.emoji,
                          style: const TextStyle(fontSize: 18))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(cat.name,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,
                          color: cs.onSurface))),
                      const Icon(CupertinoIcons.chevron_right,
                        size: 16, color: CupertinoColors.systemGrey),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}

class _CategoryEditSheet extends StatefulWidget {
  final TransactionCategory? initial;
  final ValueChanged<TransactionCategory> onSave;
  final VoidCallback? onDelete;

  const _CategoryEditSheet({this.initial, required this.onSave, this.onDelete});

  @override
  State<_CategoryEditSheet> createState() => _CategoryEditSheetState();
}

class _CategoryEditSheetState extends State<_CategoryEditSheet> {
  late TextEditingController _nameCtrl;
  late TextEditingController _emojiCtrl;
  final FocusNode _emojiFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _emojiCtrl = TextEditingController(text: widget.initial?.emoji ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _emojiCtrl.dispose(); _emojiFocus.dispose();
    super.dispose();
  }

  bool _isEmojiOnly(String s) => s.isEmpty || !RegExp(r'[\x20-\x7E]').hasMatch(s);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isEditing = widget.initial != null;

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
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: cs.outlineVariant, borderRadius: BorderRadius.circular(2)),
          )),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(isEditing ? 'Edit Category' : 'New Category',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cs.onSurface)),
            const Spacer(),
            if (widget.onDelete != null)
              GestureDetector(
                key: const Key('btn_delete_category'),
                onTap: widget.onDelete,
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
          const SizedBox(height: 20),
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _emojiCtrl,
                builder: (_, val, __) {
                  final emoji   = val.text.trim();
                  final fieldBg = emoji.isNotEmpty
                      ? EmojiColor.backgroundFor(emoji)
                      : cs.surfaceContainerHighest;
                  return Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color: fieldBg,
                      borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      key: const Key('input_cat_emoji'),
                      controller: _emojiCtrl, focusNode: _emojiFocus,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 24),
                      maxLength: 8,
                      buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                      decoration: const InputDecoration(
                        hintText: '😀',
                        hintStyle: TextStyle(fontSize: 24),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[\x20-\x7E]')),
                        _SingleEmojiFormatter(),
                      ],
                      onTap: () => _emojiCtrl.selection =
                          TextSelection.collapsed(offset: _emojiCtrl.text.length),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              Expanded(child: CupertinoTextField(
                key: const Key('input_cat_name'),
                controller: _nameCtrl, placeholder: 'Category name',
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                autofocus: !isEditing,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: cs.onSurface),
                placeholderStyle: TextStyle(color: cs.onSurfaceVariant),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12)),
              )),
            ]),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            key: const Key('btn_save_category'),
            onTap: () {
              final name  = _nameCtrl.text.trim();
              final emoji = _emojiCtrl.text.trim();
              if (name.isNotEmpty && emoji.isNotEmpty && _isEmojiOnly(emoji)) {
                widget.onSave(TransactionCategory(
                  id: widget.initial?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name, emoji: emoji,
                ));
                Navigator.pop(context);
              } else if (emoji.isNotEmpty && !_isEmojiOnly(emoji)) {
                HapticFeedback.lightImpact();
              }
            },
            child: Container(
              width: double.infinity, height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.cardLightStart, AppColors.cardLightEnd],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(
                  color: AppColors.cardLightStart.withValues(alpha: 0.3),
                  blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: const Text('Save',
                style: TextStyle(color: Colors.white, fontSize: 16,
                  fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SingleEmojiFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    final chars = text.characters;
    if (chars.length <= 1) return newValue;
    final last = chars.last;
    return TextEditingValue(text: last, selection: TextSelection.collapsed(offset: last.length));
  }
}
