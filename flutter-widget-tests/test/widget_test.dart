import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendy/main.dart';

Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const SpendyPro());
  await tester.pumpAndSettle();
}

Future<void> openAddTransactionSheet(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('btn_add_transaction')));
  await tester.pumpAndSettle();
}

Future<void> fillAndSaveTransaction(
  WidgetTester tester, {
  String title = 'Coffee run',
  String amount = '4.50',
}) async {
  await tester.enterText(find.byKey(const Key('input_tx_title')), title);
  await tester.enterText(find.byKey(const Key('input_tx_amount')), amount);
  await tester.tap(find.byKey(const Key('btn_save_transaction')));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'categories':
          '[{"id":"food","name":"Food","emoji":"🍔"},{"id":"transport","name":"Transport","emoji":"🚌"}]',
      'transactions':
          '[{"id":"mock_5","title":"Coffee","amount":4.5,"date":"2026-09-01T00:00:00.000","categoryId":"food","isPlanned":false},'
          '{"id":"mock_6","title":"Bus ticket","amount":2.0,"date":"2026-09-01T00:00:00.000","categoryId":"transport","isPlanned":false}]',
      'budget': 5000.0,
      'require_confirm': true,
    });
  });

  group('Home screen', () {
    testWidgets('TC-01: tapping add button opens Add Transaction sheet',
        (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byKey(const Key('btn_add_transaction')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('input_tx_title')), findsOneWidget);
    });

    testWidgets('TC-04: tapping a transaction tile opens the detail sheet',
        (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byKey(const Key('tile_transaction_mock_5')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('btn_edit_transaction')), findsOneWidget);
    });

    testWidgets('TC-06: selecting a category chip filters the list to that category',
        (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byKey(const Key('chip_cat_food')));
      await tester.pumpAndSettle();
      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('Bus ticket'), findsNothing);
    });

    testWidgets('TC-07: tapping "All" chip after a filter clears the filter',
        (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byKey(const Key('chip_cat_food')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('chip_all')));
      await tester.pumpAndSettle();
      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('Bus ticket'), findsOneWidget);
    });

    testWidgets('TC-10: tapping the balance edit icon switches to edit mode',
        (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byKey(const Key('edit_balance_icon')));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byKey(const Key('done_editing_balance_icon')), findsOneWidget);
    });
  });

  group('Search', () {
    testWidgets('TC-05: entering text in the search bar filters the list',
        (tester) async {
      await pumpApp(tester);
      await tester.enterText(find.byKey(const Key('search_bar')), 'Coffee');
      await tester.pumpAndSettle();
      final cellTextFinder = find.descendant(
        of: find.byType(ListView),
        matching: find.text('Coffee'),
      );
      expect(cellTextFinder, findsOneWidget);
    });

    testWidgets('TC-08: search with no matches shows an empty list',
        (tester) async {
      await pumpApp(tester);
      await tester.enterText(
        find.byKey(const Key('search_bar')),
        'zzznosuchtransaction',
      );
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: find.byType(ListView), matching: find.text('Coffee')),
        findsNothing,
      );
    });
  });

  group('Add Transaction sheet', () {
    testWidgets('TC-02: entering text in the title field displays it',
        (tester) async {
      await pumpApp(tester);
      await openAddTransactionSheet(tester);
      await tester.enterText(
        find.byKey(const Key('input_tx_title')),
        'Groceries run',
      );
      await tester.pumpAndSettle();
      expect(find.text('Groceries run'), findsOneWidget);
    });

    testWidgets('TC-03: saving a valid transaction closes the sheet',
        (tester) async {
      await pumpApp(tester);
      await openAddTransactionSheet(tester);
      await fillAndSaveTransaction(tester);
      expect(find.byKey(const Key('input_tx_title')), findsNothing);
    });

    testWidgets('TC-09: a newly saved transaction appears in the home list',
        (tester) async {
      await pumpApp(tester);
      await openAddTransactionSheet(tester);
      await fillAndSaveTransaction(tester, title: 'Widget test lunch');
      expect(find.text('Widget test lunch'), findsOneWidget);
    });
  });
}