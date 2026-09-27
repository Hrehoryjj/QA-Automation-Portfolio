# Flutter Widget Tests: Mobile App Test Automation

[![Flutter Widget Tests](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/flutter-widget-tests.yml/badge.svg)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/flutter-widget-tests.yml)

## What it is
Automated tests for **Spendy**, a demo expense-tracking mobile app built with Flutter. The tests simulate a user tapping, typing and searching through the app's screens and check that each action gives the right result.

## Why it matters
Widget tests run in seconds on a regular computer, with no phone or emulator. That makes them cheap to run on every code change, so broken behavior is caught before the app reaches a device.

## What is tested
- **Home screen:** opening the Add Transaction form, opening transaction details, filtering by category and clearing the filter, editing the balance.
- **Search:** filtering the list by text, and an empty result when nothing matches.
- **Add Transaction:** typing a title, saving a transaction, and seeing the new transaction in the list.

Tests find elements through the app's stable Widget Keys, not visible text, so they do not break when wording changes. While writing them, a real bug in the app was found and fixed: all category chips shared the same key, so tests could not tell them apart.

## How it is built
| Part | Tool |
|---|---|
| Framework | Flutter test (`flutter_test`) |
| Language | Dart |
| Structure | Tests grouped by screen with `group()` and shared `setUp()` |
| CI/CD | GitHub Actions: runs all tests on every push |

## Test results
Every run is visible in **[GitHub Actions](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/flutter-widget-tests.yml)**: the "Run widget tests" step lists each test and its result.

## Run it locally
Requires Flutter 3.x and Git.
```bash
git clone https://github.com/Hrehoryjj/QA-Automation-Portfolio.git
cd QA-Automation-Portfolio/flutter-widget-tests
flutter pub get
flutter test test/widget_test.dart                   # all tests
flutter test test/widget_test.dart --name "TC-01"    # one test
```
A successful run ends with `All tests passed!`.
