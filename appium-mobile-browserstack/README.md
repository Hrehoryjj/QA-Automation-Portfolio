# Appium + WebdriverIO: Mobile Test Automation on BrowserStack

[![Appium Mobile (BrowserStack)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/appium-mobile-browserstack.yml/badge.svg)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/appium-mobile-browserstack.yml)

## What it is
Automated tests for an **Android app** (Android-NativeDemoApp, included in this folder as an .apk). Instead of a person tapping through the app on a phone, the tests fill in forms, swipe screens, drag items into place and sign up a user, then report what passed.

## Why it matters
Real users have many different phones. The tests run on **real Android devices in the cloud (BrowserStack)**, on two models, so the app is checked across devices without owning them.

## What is tested
Form inputs, swipe gestures and a carousel, drag and drop, and user sign-up. Each check is written as an ISTQB-style test case, with random input data generated for every run.

## How it is built
| Part | Tool |
|---|---|
| Mobile automation | Appium (via WebdriverIO) |
| Device cloud | BrowserStack App Automate |
| Devices | Samsung Galaxy S22 Ultra, Google Pixel 8 Pro |
| Structure | Page Object Model, locators found with Appium Inspector |
| Test data | Faker (random data) |
| Report | Allure |
| CI/CD | GitHub Actions, BrowserStack credentials kept in GitHub Secrets |

## Test report
Latest report: **[https://hrehoryjj.github.io/QA-Automation-Portfolio/appium-mobile-browserstack/](https://hrehoryjj.github.io/QA-Automation-Portfolio/appium-mobile-browserstack/)**

## Run it locally
Requires Node.js 18+, Git and a BrowserStack account.
```bash
git clone https://github.com/Hrehoryjj/QA-Automation-Portfolio.git
cd QA-Automation-Portfolio/appium-mobile-browserstack
npm install
```
Create a `.env` file in this folder with your BrowserStack credentials (never commit it):
```
BROWSERSTACK_USERNAME=your_username
BROWSERSTACK_ACCESS_KEY=your_access_key
BROWSERSTACK_APP_ID=bs://NativeDemoApp
```
Upload the app once:
```bash
curl -u "$BROWSERSTACK_USERNAME:$BROWSERSTACK_ACCESS_KEY" \
  -X POST "https://api-cloud.browserstack.com/app-automate/upload" \
  -F "file=@Android-NativeDemoApp-0.4.0.apk" -F "custom_id=NativeDemoApp"
```
Run and open the report:
```bash
npm run wdio            # device 1
npm run wdio:device2    # device 2
npm run wdio:all        # both
npm run report          # builds and opens the Allure report
```
