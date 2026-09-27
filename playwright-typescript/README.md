# Redmine Test Automation Project (Playwright + POM)

This repository contains an automated testing suite for the Redmine platform. The project is built using TypeScript, follows the Page Object Model (POM) pattern, and integrates Allure Reports with a CI/CD pipeline.

Live Allure Report with build history: https://github.io

## Requirements
* Node.js (LTS version)
* npm
* Git

## Steps to Install
Clone the monorepo and install all required dependencies:
```bash
git clone https://github.com/Hrehoryjj/LuxeQuality.git
cd LuxeQuality/task.2
npm install
```

## Steps to Launch
To run the test suite in headless mode (same as the CI pipeline):
```bash
npm run test:headless
```

To open the interactive Playwright UI mode for debugging and step-by-step execution:
```bash
npx playwright test --ui
```

## Steps to Creating the Report
Generate a fresh static Allure report based on your local test results:
```bash
npm run allure:generate
```

Launch a local web server to open and view the generated report in your browser:
```bash
npm run allure:open
```

## Implementation Highlights
* **Test Cases:** Designed in alignment with ISTQB concepts. Test logic is isolated, step-by-step flows are clear, and every test case contains meaningful assertions (expect) inside the spec files.
* **Page Object Model:** Web elements are isolated within getters as clean constants. Methods are called on-demand within scenarios, and the code is stripped of unused imports or redundant spacing.
* **Data Management:** Valid credentials are maintained in a secure JSON file. Negative test conditions and inputs leverage dynamic, random string generation directly within the spec file.
* **CI/CD Pipeline:** Powered by GitHub Actions. On every push, the workflow sets up the environment, executes tests, fetches the history from previous runs to maintain Allure trends, and deploys the updated report to GitHub Pages.
