# AI-Assisted Test Generation: Claude Code, Cursor (Playwright MCP) and Cypress cy.prompt

[![AI Test Generation (Playwright MCP)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/ai-test-generation-mcp-playwright.yml/badge.svg)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/ai-test-generation-mcp-playwright.yml)

## What it is
A hands-on comparison of three ways to have **AI write browser tests** for the same demo online shop (automationexercise.com):
- **Claude Code + Playwright MCP** (`playwright-project/tests/claude-code/`)
- **Cursor + Playwright MCP** (`playwright-project/tests/cursor/`)
- **Cypress cy.prompt**, Cypress's own AI command (`cypress-project/`)

## Why it matters
AI tools write tests fast, but a green test is not always a correct test. The goal was to find out how far each tool can be trusted, and what a QA engineer has to verify before accepting AI-generated code.

## How the AI was controlled
- **Same rules for every tool** (`CLAUDE.md` and `.cursor/rules/testing.mdc`): Page Object Model, locators discovered in the live browser through MCP instead of guessed, no hardcoded waits, exact-value assertions, generated test data with fixture cleanup, naming conventions, a fixed folder layout (`pageObjects/`, `specs/`, `fixtures/`, `api/`, `testData/`) and mandatory ESLint + Prettier, which CI enforces. Sections 12-16 were added after the mentor review, to state requirements that had only been checked by hand.
- **Every test reviewed** against a checklist: steps match the test case, assertions are specific, no locators in test files.
- **Negative control:** expected values were broken on purpose to prove each test can actually fail.
- **Stability check:** every test repeated 10 times in a row; failures traced to server load and fixed by limiting parallel runs, not by hiding them with retries.
- Every prompt, iteration and manual fix is logged in [`prompts.md`](prompts.md).

## Key findings
- **Claude Code** followed the rules and verified every locator; later tests passed on the first try.
- **Cursor** silently ignored its rules file because of a wrong file extension: tests passed, but with weaker locators and assertions.
- **cy.prompt** was quick to write but needed the most correction; its AI-evaluated checks were too vague to decide pass/fail, so final checks were written as regular code.

Full results, tables and limitations: [FINDINGS.md](FINDINGS.md).

## How it is built
| Part | Tool |
|---|---|
| AI agents | Claude Code, Cursor, Cypress cy.prompt (Cypress Cloud) |
| Browser access for AI | Playwright MCP server |
| Test frameworks | Playwright, Cypress |
| Language | TypeScript |
| Report | Playwright HTML report, Mochawesome for Cypress |
| CI/CD | GitHub Actions |

## Test report
The HTML report of every run is attached to the run in **[GitHub Actions](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/ai-test-generation-mcp-playwright.yml)** (Artifacts, "playwright-report").

## Run it locally
Requires Node.js 22 and Git.
```bash
git clone https://github.com/Hrehoryjj/QA-Automation-Portfolio.git
cd QA-Automation-Portfolio/ai-test-generation-mcp/playwright-project
npm ci
npx playwright install chromium
npx playwright test          # all Playwright tests
npm run test:claude          # Claude Code tests only
npm run test:cursor          # Cursor tests only
npm run report               # open the HTML report
npm run lint                 # ESLint (typescript-eslint + eslint-plugin-playwright)
npm run format:check         # Prettier
```
The Cypress part (`cypress-project/`) needs a Cypress Cloud login, because cy.prompt runs only with it.
