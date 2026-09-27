# QA Automation Portfolio

Hryhorii Markevych

This repository collects my test automation projects: web, API, mobile and AI testing. Each folder is a separate, working project with its own tests, CI pipeline and a README explaining what it does, why and how to run it.

## What you will find here
- **Web UI automation** in four frameworks: Playwright (TypeScript and Python), Cypress, WebdriverIO
- **API testing** with Postman and Newman
- **Mobile testing** on real cloud devices (Appium, BrowserStack) and Flutter widget tests
- **AI testing:** checking the quality and safety of LLM answers, and generating tests with AI agents under strict review
- **Engineering practices** used across projects: Page Object Model, BDD, test data generation, Docker, CI/CD with GitHub Actions, Allure reports published online

## Projects
| Project | What it shows | Stack | Report |
|---|---|---|---|
| [playwright-typescript](playwright-typescript) | UI tests for a project management web app | Playwright, TypeScript, Allure | [Report](https://hrehoryjj.github.io/QA-Automation-Portfolio/playwright-typescript/) |
| [playwright-python-pytest](playwright-python-pytest) | Cross-browser regression of an online shop, Slack alerts | Playwright, Python, pytest, Allure | [Report](https://hrehoryjj.github.io/QA-Automation-Portfolio/playwright-python-pytest/) |
| [cypress-typescript](cypress-typescript) | UI tests for a company marketing website | Cypress, TypeScript, Allure | [Report](https://hrehoryjj.github.io/QA-Automation-Portfolio/cypress-typescript/) |
| [cypress-cucumber-bdd](cypress-cucumber-bdd) | Tests written as plain-English scenarios (BDD) | Cypress, Cucumber, TypeScript | [Report](https://hrehoryjj.github.io/QA-Automation-Portfolio/cypress-cucumber-bdd/) |
| [webdriverio-typescript](webdriverio-typescript) | E2E tests running in Docker | WebdriverIO, TypeScript, Docker, Allure | [Report](https://hrehoryjj.github.io/QA-Automation-Portfolio/webdriverio-typescript/) |
| [postman-newman-api](postman-newman-api) | REST API tests: status codes, schema, full data lifecycle | Postman, Newman | [CI runs](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/postman-newman-api.yml) |
| [appium-mobile-browserstack](appium-mobile-browserstack) | Android app tests on two real cloud devices | Appium, WebdriverIO, BrowserStack | [Report](https://hrehoryjj.github.io/QA-Automation-Portfolio/appium-mobile-browserstack/) |
| [flutter-widget-tests](flutter-widget-tests) | Fast UI tests for a Flutter mobile app | Flutter, Dart | [CI runs](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/flutter-widget-tests.yml) |
| [llm-testing-deepeval](llm-testing-deepeval) | Quality and safety checks of AI model answers | DeepEval, Python, Ollama | [CI runs](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/llm-testing-deepeval.yml) |
| [ai-test-generation-mcp](ai-test-generation-mcp) | Comparing AI agents that write tests, and how to verify their output | Claude Code, Cursor, Playwright MCP, Cypress cy.prompt | [CI runs](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/ai-test-generation-mcp-playwright.yml) |

## How to look at a project
1. Open the project folder and read its README: what it tests and why, in plain language.
2. Click **Report** in the table above to see the latest test results in the browser, no setup needed.
3. To run the tests yourself, follow "Run it locally" in the project README.

## Contact
[LinkedIn](https://www.linkedin.com/in/hryhorii-markevych-543b33164/) | markevych.hr@gmail.com
