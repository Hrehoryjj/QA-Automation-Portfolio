# Playwright + TypeScript: UI Test Automation

[![Playwright (TypeScript)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/playwright-typescript.yml/badge.svg)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/playwright-typescript.yml)

## What it is
Automated browser tests for **Redmine**, a widely used open-source project management web app. The tests open a real browser and go through the app the way a user would, then report what works and what is broken.

## Why it matters
Checking the same screens by hand after every change is slow and easy to get wrong. This suite repeats the checks in minutes, the same way every time, and runs automatically on every code change.

## What is tested
- **Login:** valid credentials, empty fields and invalid credentials (the app must reject the last two with a clear message).
- **Issue filtering:** filtering the issue list by coordinator and by author, and adding an author column to the table.

Test cases follow ISTQB test design principles, and every test ends with explicit pass/fail checks.

## How it is built
| Part | Tool |
|---|---|
| Browser automation | Playwright |
| Language | TypeScript |
| Structure | Page Object Model: each page is one class, tests stay short and readable |
| Test data | Stored credentials in a JSON file, random data for negative cases |
| Report | Allure, with history of previous runs |
| CI/CD | GitHub Actions: runs tests and publishes the report on every push |

## Test report
Latest report: **[https://hrehoryjj.github.io/QA-Automation-Portfolio/playwright-typescript/](https://hrehoryjj.github.io/QA-Automation-Portfolio/playwright-typescript/)**

## Run it locally
Requires Node.js (LTS) and Git.
```bash
git clone https://github.com/Hrehoryjj/QA-Automation-Portfolio.git
cd QA-Automation-Portfolio/playwright-typescript
npm install
npx playwright install
npm run test:headless        # run all tests
npx playwright test --ui     # interactive mode, step by step
```
Open the report (requires Java for the Allure CLI):
```bash
npm run allure:generate
npm run allure:open
```
