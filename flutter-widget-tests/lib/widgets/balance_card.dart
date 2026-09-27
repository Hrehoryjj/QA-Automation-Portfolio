import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'currency_formatter.dart';
import '../main.dart' show AppColors;

class BalanceCard extends StatefulWidget {
  final double totalBalance;
  final double totalBudget;
  final Function(double) onBalanceChanged;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.totalBudget,
    required this.onBalanceChanged,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> with SingleTickerProviderStateMixin {
  bool _isEditing = false;
  late TextEditingController _ctrl;
  final FocusNode _focusNode = FocusNode();
  bool _hasInput = false;
  bool _animatingToEdit = false;
  final ScrollController _scrollCtrl = ScrollController();

  late AnimationController _barAnim;
  late Animation<double> _barProgress;
  double _lastProgress = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
    _ctrl.addListener(() {
      setState(() => _hasInput = _ctrl.text.isNotEmpty);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollCtrl.hasClients) {
          _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
        }
      });
    });
    _barAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _lastProgress = _computeProgress();
    _barProgress = Tween<double>(begin: 0, end: _lastProgress)
        .animate(CurvedAnimation(parent: _barAnim, curve: Curves.easeOutCubic));
    _barAnim.forward();
  }

  @override
  void didUpdateWidget(BalanceCard old) {
    super.didUpdateWidget(old);
    final np = _computeProgress();
    if (np != _lastProgress) {
      _barProgress = Tween<double>(begin: _lastProgress, end: np)
          .animate(CurvedAnimation(parent: _barAnim, curve: Curves.easeOutCubic));
      _lastProgress = np;
      _barAnim..reset()..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose(); _scrollCtrl.dispose(); _focusNode.dispose(); _barAnim.dispose();
    super.dispose();
  }

  double _computeProgress() {
    if (widget.totalBudget <= 0) return 0;
    return ((widget.totalBudget - widget.totalBalance) / widget.totalBudget).clamp(0.0, 1.0);
  }

  Color _barColor(double p) {
    if (p >= 1.0) return const Color(0xFFFF3B30);
    if (p >= 0.75) return const Color(0xFFFF9500);
    return const Color(0xFF34C759);
  }

  void _toggleEdit() {
    if (_isEditing) return;
    setState(() => _animatingToEdit = true);
    Future.delayed(const Duration(milliseconds: 180), () {
      setState(() { _isEditing = true; _animatingToEdit = false; _ctrl.clear(); _hasInput = false; });
      _focusNode.requestFocus();
    });
  }

  void _save() {
    if (_ctrl.text.isEmpty && widget.totalBalance < 0) {
      setState(() { _isEditing = false; _animatingToEdit = true; });
      _ctrl.clear();
      Future.delayed(const Duration(milliseconds: 180), () => setState(() => _animatingToEdit = false));
      return;
    }
    final val = double.tryParse(_ctrl.text.replaceAll(',', ''));
    if (val != null) widget.onBalanceChanged(val < 0 ? val.abs() : val);
    setState(() => _isEditing = false);
    _ctrl.clear();
  }

  String _fmt(double v) {
    final parts = v.abs().toStringAsFixed(2).split('.');
    String intP = parts[0].isEmpty ? '0' : parts[0];
    final buf = StringBuffer();
    int c = 0;
    for (int i = intP.length - 1; i >= 0; i--) {
      buf.write(intP[i]); c++;
      if (c == 3 && i != 0) { buf.write(','); c = 0; }
    }
    return '${buf.toString().split('').reversed.join()}.${parts[1]}';
  }

  String _display(double v) => '${v < 0 ? "-" : ""}\$${_fmt(v.abs())}';

  @override
  Widget build(BuildContext context) {
    final spent        = widget.totalBudget - widget.totalBalance;
    final isOverBudget = widget.totalBalance < 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.cardLightStart, AppColors.cardLightEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardLightStart
                .withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('AVAILABLE BALANCE', style: TextStyle(
              color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.6,
            )),
            GestureDetector(
              onTap: _isEditing ? _save : _toggleEdit,
              child: Icon(
                key: !_isEditing ? const Key('edit_balance_icon') : const Key('done_editing_balance_icon'),
                _isEditing ? Icons.check_rounded : Icons.edit_note_rounded,
                color: Colors.white54, size: 19,
              ),
            ),
          ]),

          const SizedBox(height: 10),

          SizedBox(
            height: 48,
            child: _isEditing
                ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const Text('\$', style: TextStyle(
                      color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800, letterSpacing: -1.5)),
                    const SizedBox(width: 3),
                    Expanded(child: Stack(alignment: Alignment.centerLeft, children: [
                      Opacity(
                        opacity: _hasInput ? 0.0 : 0.3,
                        child: Text(
                          widget.totalBalance < 0 ? '0.00' : _fmt(widget.totalBalance.abs()),
                          style: const TextStyle(color: Colors.white, fontSize: 38,
                              fontWeight: FontWeight.w800, letterSpacing: -1.5),
                        ),
                      ),
                      TextField(
                        controller: _ctrl, scrollController: _scrollCtrl, focusNode: _focusNode,
                        maxLines: 1, textAlign: TextAlign.start, textAlignVertical: TextAlignVertical.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d\.,]')),
                          NaturalCurrencyFormatter(),
                        ],
                        style: const TextStyle(color: Colors.white, fontSize: 38,
                            fontWeight: FontWeight.w800, letterSpacing: -1.5),
                        decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                        onSubmitted: (_) => _save(),
                      ),
                    ])),
                  ])
                : GestureDetector(
                    onTap: _toggleEdit,
                    child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      if (widget.totalBalance < 0)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 180),
                          opacity: _animatingToEdit ? 0.0 : 1.0,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            transform: Matrix4.translationValues(_animatingToEdit ? -16.0 : 0.0, 0, 0),
                            child: const Text('-', style: TextStyle(color: Colors.white, fontSize: 38,
                                fontWeight: FontWeight.w800, letterSpacing: -1.5)),
                          ),
                        ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        transform: Matrix4.translationValues(
                          widget.totalBalance < 0 && _animatingToEdit ? -16.0 : 0.0, 0, 0),
                        child: Text(_display(widget.totalBalance).replaceFirst('-', ''),
                          style: const TextStyle(color: Colors.white, fontSize: 38,
                              fontWeight: FontWeight.w800, letterSpacing: -1.5)),
                      ),
                    ]),
                  ),
          ),

          const SizedBox(height: 16),

          AnimatedBuilder(
            animation: _barProgress,
            builder: (_, __) {
              final p     = _barProgress.value;
              final color = _barColor(p);
              final pct   = '${(p * 100).toStringAsFixed(0)}%';

              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                    child: Text(
                      isOverBudget
                          ? '\$${_fmt((spent - widget.totalBudget).abs())} over budget'
                          : 'Spent  \$${_fmt(spent.clamp(0, double.infinity))} of \$${_fmt(widget.totalBudget)}',
                      style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(pct, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    height: 5,
                    child: Stack(children: [
                      Container(color: Colors.white10),
                      FractionallySizedBox(
                        widthFactor: p,
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ]);
            },
          ),
        ],
      ),
    );
  }
}
