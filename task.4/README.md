# Task 4 — Cypress + Cucumber: telnyx.com

## About this repo folder
Automated UI test suite for the public site [telnyx.com](https://telnyx.com),
built with Cypress and Cucumber (Gherkin — human-readable Given/When/Then
scenarios) using the Page Object Model. Covers the homepage, header navigation,
pricing data, the Contact Us form, and footer link validation. No sign up or
log in flow is exercised anywhere in this suite.

## Requirements
- Node.js 18+
- npm
- Google Chrome (for local runs)

## How to get the code
```bash
git clone <repository URL>
cd <repository-name>/task.4
```

## Install
```bash
npm install
```

## Run the tests
Interactive (see the browser step by step):
```bash
npm run cypress:open
```
Headless, all tests:
```bash
npm run cypress:run
```

## View the report
The HTML report is generated automatically as part of `cypress:run` (via
`cypress-mochawesome-reporter`) — no separate command needed. Open
`cypress/reports/index.html` in a browser afterwards. It includes a
pass/fail summary chart and screenshots for any failed steps.

## CI
Every push or Pull Request that touches this folder triggers GitHub Actions
automatically. The generated HTML report is published to GitHub Pages after
a merge to `main`.

## Known issue: occasional cross-origin flakiness (not a test gap)
telnyx.com has recently adopted newer browser-level features (e.g. an
AI-agent integration API) and loads several third-party scripts (chat,
analytics, marketing). Cypress runs by embedding the site inside its own
runner window, which can put the browser in a state a few of those
third-party scripts weren't written to expect — they then throw an
uncaught error unrelated to the page or feature actually under test,
surfacing as a generic `Script error.` with no stack trace.

This is an interaction between the site's own third-party scripts and
Cypress's architecture, not a defect in this suite. The most common
trigger (a specific new browser API) has been root-caused and fixed
(`cypress/support/e2e.js`); any real assertion failure still reports
with a specific message and still fails the build as expected. A run
that fails only with a bare `Script error.` is safe to re-run.