# Cypress + TypeScript: UI Test Automation

[![Cypress (TypeScript)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/cypress-typescript.yml/badge.svg)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/cypress-typescript.yml)

## What it is
Automated tests for the public marketing website of **Telnyx** (telnyx.com), a cloud communications company. The tests check the parts of the site a visitor relies on: page loading, navigation menus, pricing pages, the AI chat widget and footer links.

## Why it matters
A marketing site changes often, and a broken link or a missing price costs real customers. This suite acts as a safety net: after every change it confirms in a few minutes that nothing important broke, and leaves a report with screenshots of any failure.

## How it is built
| Part | Tool |
|---|---|
| Browser automation | Cypress |
| Language | TypeScript |
| Structure | Page Object Model |
| Report | Allure, with screenshots of failed steps |
| CI/CD | GitHub Actions: runs tests and publishes the report on every push |

## Test report
Latest report: **[https://hrehoryjj.github.io/QA-Automation-Portfolio/cypress-typescript/](https://hrehoryjj.github.io/QA-Automation-Portfolio/cypress-typescript/)**

## Run it locally
Requires Node.js 18+ and Git.
```bash
git clone https://github.com/Hrehoryjj/QA-Automation-Portfolio.git
cd QA-Automation-Portfolio/cypress-typescript
npm install
npm test              # run all tests in the background
npm run test:open     # watch tests run in a browser window
npm run report:generate
npm run report:open   # open the report in your browser
```

## Good to know
The site loads many third-party scripts (chat, analytics, marketing). Cypress runs the site inside its own window, and a few of those scripts occasionally throw an error unrelated to the feature under test. The most common cause was found and fixed in `cypress/support/e2e.ts`. Real failures always name the exact check that failed; a bare "Script error" is this known external noise and passes on re-run.
