# Spendy — Widget Testing (Task 9)

## Summary

This project contains automated tests for **Spendy**, a demo expense-tracking
mobile app built with Flutter. The tests check that the app's main screens
and actions behave correctly — for example, that tapping "Add" opens the
right form, that typed text actually appears where it should, that saving a
transaction works, and that search and filters return the expected results.

These are called **widget tests**: instead of installing the app on a phone
and clicking through it manually, the tests run automatically and simulate a
user tapping, typing, and swiping through the app's screens. This makes it
possible to catch broken behavior quickly, every time the code changes,
without a human having to retest everything by hand.

The test suite covers 10 scenarios in total — 5 required ones (adding a
transaction, viewing a transaction's details, searching) and 5 additional
ones written to cover extra everyday actions (filtering by category, saving
a new transaction and seeing it appear in the list, editing the budget, and
so on).

## Requirements

To run this project you need:

- **Flutter** installed on your machine (version 3.0 or newer) — this is the
  toolkit the app and its tests are built with. Installation guide:
  https://docs.flutter.dev/get-started/install
- **Git**, to download the project

No phone, emulator, or Flutter development experience is required to just
run the tests — they run entirely on your computer in a few seconds.

## How to Set It Up

1. Download the project:
   ```bash
   git clone <repository-url>
   cd task.9
   ```
2. Install the app's dependencies (this downloads everything the app needs
   to run):
   ```bash
   flutter pub get
   ```

## How to Run the Tests

From inside the project folder, run:

```bash
flutter test test/widget_test.dart
```

You'll see a list of test names scroll by, each marked with a checkmark if
it passed. If everything is working correctly, you'll see something like:

```
00:03 +10: All tests passed!
```

If a test fails, Flutter will print which one and why — usually pointing to
the exact screen element and expected vs. actual result, which makes it easy
to spot what changed in the app.

To run just one test (useful when checking a single fix), use its name from
the list, for example:

```bash
flutter test test/widget_test.dart --name "TC-01"
```