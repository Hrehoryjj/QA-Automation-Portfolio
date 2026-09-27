# Telnyx Website — Automated Testing Suite

## What is this repository?

This repository contains automated tests that check whether the [Telnyx] marketing website works correctly. Instead of a person manually clicking through the site every time something changes, these tests do it automatically — checking navigation menus, pricing pages, the AI chat widget, and footer links.

Think of it as a safety net: whenever the website is updated, these tests can be run to quickly confirm that nothing important has broken (a broken link, a page that no longer loads, a button that stopped working).

## Why does this exist?

Manually testing a website by hand takes time and is easy to get wrong — a person might forget to check a link, or miss that a page loads slowly. Automated tests:

- Run in a few minutes instead of an hour of manual clicking
- Check the exact same things every time, with no human error
- Can run automatically whenever code changes are pushed (see the CI/CD section below)
- Leave a clear report showing exactly what passed and what failed, and why

## What's actually being tested?

The suite covers key areas of the website's user experience — things like page loading, navigation, pricing information, the AI chat feature, and footer links. The full list of what's tested is available in the test files themselves inside the `cypress/e2e/` folder, for anyone who wants the technical detail.

## Requirements

Before running anything, make sure you have:

- **Node.js** (version 18 or higher) installed on your computer — [download here](https://nodejs.org/)
- **Git** installed — [download here](https://git-scm.com/downloads)
- A code editor (optional, but recommended) such as [Visual Studio Code](https://code.visualstudio.com/)

## How to download this repository

1. Open a terminal (Command Prompt, PowerShell, or Terminal app)
2. Navigate to the folder where you want the project saved
3. Run:
```bash
   git clone <repository-url>
```
4. Move into the project folder:
```bash
   cd task.3.cypress
```

## How to install and run the tests

### Step 1 — Install dependencies

This downloads everything the project needs to run (only needs to be done once, or whenever dependencies change):
```bash
npm install
```

### Step 2 — Run the tests

**Headless mode** (runs in the background, no browser window pops up — this is what runs automatically in CI/CD):
```bash
npm test
```

**Interactive mode** (opens a visual browser window where you can watch each test run step by step — useful for debugging or demos):
```bash
npm run test:open
```

## How to view the test report

After running the tests, a detailed report can be generated showing what passed, what failed, and why — including screenshots of any failures.

```bash
npm run report:generate
npm run report:open
```

The second command automatically opens the report in your browser. It includes pass/fail counts, timing information, and screenshots for any test that failed.

## Automated runs (CI/CD)

This project is connected to GitHub Actions, which means the full test suite automatically runs every time someone pushes new code or opens a pull request. You don't need to do anything manually for this — it happens in the background, and the results are visible in the **Actions** tab of the GitHub repository.

This means that before any code change is merged, we already know whether it broke anything on the website.

## A note on occasional test flakiness

Once in a while a CI run may show a test as failed even though nothing is actually broken on the website. This is a known, understood, and expected side effect of *how* the site is built — not a gap in what we test or a bug in the suite itself.

**What's happening:** the Telnyx website has recently adopted some newer browser-level capabilities (for example, AI-agent integrations) and loads a number of third-party scripts (chat widgets, analytics, marketing tools). Cypress, the tool driving these tests, works by embedding the website inside its own runner window. That embedding occasionally puts the browser into a state a couple of these third-party scripts weren't written to expect, and they throw an error that has nothing to do with the page content or feature being tested — it's an interaction between the site's structure and the testing tool, not a real defect.

**What we've already done about it:**
- Root-caused and permanently fixed the most common trigger (a specific, brand-new browser API the site started using).
- Every real assertion failure (e.g. "this price is missing" or "this link is broken") still reports clearly and separately from this kind of noise, so nothing gets hidden.

**How to read a red run:** if the failure message names a specific check (a missing element, a wrong value, a broken link), that's a real result worth looking at. If it's a generic "cross-origin script error" with no further detail, it's this known, external interaction — re-running the job is enough, and it typically passes.

This is a common trade-off whenever a browser-embedding test tool is pointed at a production site loaded with third-party scripts, and is not specific to this project's test code.

## Questions or issues?

If a test fails and you're not sure why, check the generated report first — it usually shows exactly what the test expected versus what it found, plus a screenshot of the page at the moment of failure.