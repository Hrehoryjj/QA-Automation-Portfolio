# Playwright + Python (pytest): Cross-Browser E2E Test Automation

[![Playwright (Python + pytest)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/playwright-python-pytest.yml/badge.svg)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/playwright-python-pytest.yml)

## What it is
A regression suite for **automationexercise.com**, a public demo online shop. The tests drive a real browser like a shopper: sign up, log in, search, add to cart, check out, leave a review, contact support.

## Why it matters
These are the journeys that make or lose money in an online shop. The suite checks all of them on **three browsers (Chrome, Firefox, Safari engine)** on every change and publishes an Allure report, so the team learns about a broken checkout from a report, not from customers.

## What is tested
| Scenario | Why it matters |
|---|---|
| Register a new user, then delete the account | Sign-up and account removal work end to end |
| Log in with a valid / wrong password | Customers get in, bad credentials are rejected |
| Contact Us form with a file attachment | Support requests with uploads go through |
| Product catalog and product page | Listings and details render correctly |
| Product search | Results match the query |
| Add to cart, remove from cart | The cart reflects what the customer chose |
| Place an order, registering during checkout | The full purchase path works |
| Leave a product review | Reviews can be submitted |

## How it is built
| Part | Tool |
|---|---|
| Browser automation | Playwright (Python) |
| Test runner | pytest, parallel runs with pytest-xdist, automatic reruns of flaky runs |
| Browsers | Chromium, Firefox, WebKit |
| Structure | Page Object Model |
| Test data | Faker: a fresh random user, card and review on every run |
| Report | Allure, with steps, a final-state screenshot of every test and trend history |
| CI/CD | GitHub Actions, credentials in GitHub Secrets |

## Test report
Latest report: **[https://hrehoryjj.github.io/QA-Automation-Portfolio/playwright-python-pytest/](https://hrehoryjj.github.io/QA-Automation-Portfolio/playwright-python-pytest/)**

Every test ends with a screenshot of its final page state. When a test fails in CI, its Playwright trace is attached to the run as the `traces-<browser>` artifact; open it with `playwright show-trace <trace.zip>`.

## Run it locally
Requires Python 3.11+ and Git.
```bash
git clone https://github.com/Hrehoryjj/QA-Automation-Portfolio.git
cd QA-Automation-Portfolio/playwright-python-pytest
python -m venv .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate
pip install -r requirements.txt
python -m playwright install
cp .env.example .env               # add a test account for the login test
pytest                             # all tests in Chromium
pytest --browser firefox           # another browser
pytest -k tc09                     # a single test
```
Open the report (requires Java and Node.js; `npx` runs Allure without a global install):
```bash
npx allure-commandline serve allure-results
```
