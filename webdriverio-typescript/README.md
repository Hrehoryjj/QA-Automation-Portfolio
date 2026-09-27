# WebdriverIO + TypeScript: E2E Test Automation with Docker

[![WebdriverIO (TypeScript)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/webdriverio-typescript.yml/badge.svg)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/webdriverio-typescript.yml)

## What it is
End-to-end tests for the Telnyx website (telnyx.com). The tests open the site in a real Chrome browser and click through it like a user: the logo leads home, menus open, prices are shown, footer links are not broken, the contact form accepts input.

## Why it matters
In a couple of minutes the suite tells whether a site change broke a core interaction. It runs inside **Docker**, so it behaves the same on any computer and in the CI pipeline, without "works on my machine" problems.

## What is tested
Home page, header navigation, pricing, footer links and the contact form.

## How it is built
| Part | Tool |
|---|---|
| Browser automation | WebdriverIO |
| Language | TypeScript |
| Test framework | Mocha |
| Structure | Page Object Model: selectors live only in page classes, never in tests |
| Test data | Faker (random data) plus a fixed valid record |
| Environment | Docker, same image locally and in CI |
| Configs | Split into shared, local and CI configs |
| Report | Allure, screenshots saved on failure |
| CI/CD | GitHub Actions: builds the Docker image, runs tests, publishes the report |

## Test report
Latest report: **[https://hrehoryjj.github.io/QA-Automation-Portfolio/webdriverio-typescript/](https://hrehoryjj.github.io/QA-Automation-Portfolio/webdriverio-typescript/)**

## Run it locally
Requires Node.js 18+, Git and Google Chrome (or Docker, see below).
```bash
git clone https://github.com/Hrehoryjj/QA-Automation-Portfolio.git
cd QA-Automation-Portfolio/webdriverio-typescript
npm install
npm run test:local                                    # all tests, headless Chrome
npm run test:file -- test/specs/pricing.e2e.ts        # a single test file
```
Or in Docker, no local Chrome needed:
```bash
docker build -t webdriverio-typescript .
docker run --rm -v $(pwd)/allure-results:/app/allure-results webdriverio-typescript
```
Open the report:
```bash
npm run report:generate
npm run report:open
```

## Good to know
- Chrome only for now.
- Some legal footer links return 403 to automated requests (bot protection), so the test accepts 200 or 403.
- The cookie settings test depends on whether the consent widget is shown for the visitor's region; when it is absent, the report says so explicitly.
