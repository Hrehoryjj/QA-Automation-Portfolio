# Cypress + Cucumber: BDD Test Automation

[![Cypress + Cucumber (BDD)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/cypress-cucumber-bdd.yml/badge.svg)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/cypress-cucumber-bdd.yml)

## What it is
UI tests for the Telnyx website (telnyx.com) written in **BDD style**: every scenario is described in plain English (Given / When / Then) before any code. Example from `cypress/e2e/features/pricing.feature`:
```gherkin
Scenario: Pricing Page Displays Valid Price Values
  Given I navigate to the pricing page
  When I click the Messaging API pricing link
  Then the services table should be visible
  And all displayed prices should be greater than 0
```

## Why it matters
BDD scenarios can be read and agreed on by people who do not write code: product managers, analysts, business owners. The same text is the test that runs automatically, so the documentation of "how the site should behave" never goes out of date.

## What is tested
Homepage and header navigation, pricing data, the Contact Us form (including randomly generated input) and footer links, where every link is also checked with an HTTP request so broken links are caught.

## How it is built
| Part | Tool |
|---|---|
| Browser automation | Cypress |
| Scenarios | Cucumber (Gherkin) |
| Language | TypeScript |
| Structure | Page Object Model + step definitions |
| Test data | Faker (random data) and fixtures |
| Report | Mochawesome HTML report with screenshots |
| CI/CD | GitHub Actions: runs tests and publishes the report on every push |

## Test report
Latest report: **[https://hrehoryjj.github.io/QA-Automation-Portfolio/cypress-cucumber-bdd/](https://hrehoryjj.github.io/QA-Automation-Portfolio/cypress-cucumber-bdd/)**

## Run it locally
Requires Node.js 18+, Git and Google Chrome.
```bash
git clone https://github.com/Hrehoryjj/QA-Automation-Portfolio.git
cd QA-Automation-Portfolio/cypress-cucumber-bdd
npm install
npm run cypress:run    # run all scenarios, the report is created automatically
npm run cypress:open   # watch scenarios run step by step
```
The report is saved to `cypress/reports/index.html`, open it in any browser.
