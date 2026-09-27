import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../widgets/delete_confirm_dialog.dart';
import 'categories_page.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback onClearAll;
  final bool initialConfirmSetting;
  final List<TransactionCategory> categories;
  final ValueChanged<List<TransactionCategory>> onCategoriesChanged;

  const SettingsPage({
    super.key, required this.onClearAll, required this.categories,
    required this.onCategoriesChanged,
    this.initialConfirmSetting = true,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _confirmDeleteEnabled;

  @override
  void initState() {
    super.initState();
    _confirmDeleteEnabled = widget.initialConfirmSetting;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      appBar: AppBar(
        title: Text('Settings',
          style: TextStyle(fontWeight: FontWeight.bold, color: cs.onSurface)),
        backgroundColor: cs.surfaceContainerHighest,
        elevation: 0, surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: cs.onSurface),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context, _confirmDeleteEnabled),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          _SectionHeader('GENERAL', cs),
          _Card(cs: cs, children: [
            _SettingRow(
              icon: CupertinoIcons.shield,
              label: 'Confirm before deletion',
              cs: cs,
              trailing: CupertinoSwitch(
                key: const Key('switch_confirm_delete'),
                value: _confirmDeleteEnabled,
                onChanged: (v) => setState(() => _confirmDeleteEnabled = v),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(
                'When off, transactions are removed immediately after a swipe.',
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12, height: 1.4),
              ),
            ),
          ]),

          const SizedBox(height: 24),
          _SectionHeader('CUSTOMIZATION', cs),
          _Card(cs: cs, children: [
            _SettingRow(
              key: const Key('btn_categories'),
              icon: CupertinoIcons.tag,
              label: 'Categories',
              cs: cs,
              trailing: const Icon(CupertinoIcons.chevron_right,
                size: 16, color: CupertinoColors.systemGrey),
              onTap: () => Navigator.push(context, CupertinoPageRoute(
                builder: (_) => CategoriesPage(
                  categories: widget.categories,
                  onChanged: widget.onCategoriesChanged),
              )),
            ),
          ]),

          const SizedBox(height: 24),
          _SectionHeader('DATA MANAGEMENT', cs),
          _Card(cs: cs, children: [
            _SettingRow(
              key: const Key('btn_delete_all'),
              icon: CupertinoIcons.delete,
              label: 'Delete all transactions',
              cs: cs,
              labelColor: const Color(0xFFFF3B30),
              iconColor: const Color(0xFFFF3B30),
              trailing: const Icon(CupertinoIcons.delete,
                color: Color(0xFFFF3B30), size: 18),
              onTap: () => _confirmClearAll(context),
            ),
          ]),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context) {
    showGeneralDialog(
      context: context, barrierDismissible: true, barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, _, __) => DeleteConfirmDialog(
        title: 'Delete all transactions?',
        message: 'This will wipe your entire history. This action cannot be undone.',
        onConfirm: () { Navigator.pop(ctx); widget.onClearAll(); },
        onCancel: () => Navigator.pop(ctx),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  final ColorScheme cs;
  const _SectionHeader(this.text, this.cs);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(text, style: TextStyle(
      color: cs.onSurfaceVariant, fontSize: 11,
      fontWeight: FontWeight.w700, letterSpacing: 1.0)),
  );
}

class _Card extends StatelessWidget {
  final ColorScheme cs;
  final List<Widget> children;
  const _Card({required this.cs, required this.children});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: cs.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme cs;
  final Widget trailing;
  final Color? labelColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _SettingRow({
    super.key,
    required this.icon, required this.label, required this.cs,
    required this.trailing, this.labelColor, this.iconColor, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Icon(icon, size: 20,
          color: iconColor ?? cs.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500,
          color: labelColor ?? cs.onSurface))),
        trailing,
      ]),
    );
    if (onTap != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: row,
      );
    }
    return row;
  }
}
