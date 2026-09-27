# Task 10 — End-to-end tests for automationexercise.com

## What this is

An automated **regression suite** for the public demo shop
[automationexercise.com](https://www.automationexercise.com). It drives a real
browser the way a person would — clicks, typing, navigation — and verifies that
the key shopper journeys still work: signing up, logging in, searching,
adding to the cart, checking out, leaving a review, contacting support.

Every run produces a visual **Allure report**: a clickable list of scenarios,
each broken into readable steps with screenshots, plus a pass/fail trend over
time. The suite runs automatically on every change through GitHub Actions and
publishes the report to GitHub Pages, with a summary posted to Slack.

You do **not** need to be a tester to run it — the steps below are copy‑paste.

## What it checks

| # | Scenario | Why it matters |
|---|----------|----------------|
| TC‑01 | Register a new user, then delete the account | Sign‑up flow and account removal work end to end |
| TC‑02 | Log in with a valid email and password | Existing customers can get in |
| TC‑03 | Log in with a wrong email/password | Bad credentials are rejected with a clear message |
| TC‑06 | Submit the "Contact Us" form with a file attachment | Support requests (with uploads) go through |
| TC‑08 | Open the catalog and a product detail page | Product listings and detail pages render correctly |
| TC‑09 | Search for a product | Search returns results relevant to the query |
| TC‑12 | Add products to the cart | Items land in the cart with the right details |
| TC‑15 | Place an order, registering during checkout | The full buy‑as‑new‑customer path works |
| TC‑17 | Remove a product from the cart | Customers can change their mind before paying |
| TC‑21 | Leave a review on a product | Review submission works |

All ten run on every push against Chromium, Firefox and WebKit.

Scenario IDs match the site's own
[Test Cases page](https://www.automationexercise.com/test_cases).

## How it's built

| Piece | Tool | In one line |
|-------|------|-------------|
| Browser automation | **Playwright** (sync API) | Launches Chromium / Firefox / WebKit and controls them |
| Test runner | **pytest** | Finds the tests, runs them, reports results |
| Parallel execution | **pytest‑xdist** (`-n auto`) | Uses all CPU cores so the suite finishes faster |
| Structure | **Page Object Model** | Each page of the site is one Python class; tests read like a script, selectors live in one place |
| Test data | **Faker** | Generates a fresh random user / card / review per run, so tests never collide |
| Reporting | **Allure** | Turns raw results into a browsable report with steps, screenshots and history |
| Pipeline | **GitHub Actions** | Runs everything automatically on each push / pull request |

## Run it yourself

**Prerequisites:** Python 3.11 or newer.

```bash
cd task.10

python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate

pip install -r requirements.txt
python -m playwright install      # one-time browser download
```

One scenario (TC‑02) signs in with a pre‑existing account. Provide it locally:

```bash
cp .env.example .env             # then edit .env with a real account
```

Run the tests:

```bash
pytest                                   # Chromium, everything
pytest -k tc09                            # a single scenario
pytest --browser firefox                 # a different browser
pytest --browser chromium --browser firefox   # several browsers in one go
pytest -n auto                           # in parallel (CI uses -n 2 with --reruns 2 --reruns-delay 5)
```

## See the report

```bash
pytest                            # writes raw results to allure-results/
allure serve allure-results       # opens the report in your browser
```

`allure serve` needs the Allure command‑line tool (Java 8+):
`npm i -g allure-commandline`, or Scoop / Homebrew.

The report shows, per scenario: the ordered steps, a screenshot at each
milestone, the exact failure point if something breaks, and how results changed
versus previous runs.

The latest CI report is always at
**https://hrehoryjj.github.io/LuxeQuality/**.

## What runs in CI

On every push or pull request that touches `task.10/`, GitHub Actions:

1. runs the suite three times, once each on **Chromium**, **Firefox** and
   **WebKit** — one browser at a time (`max-parallel: 1`, to avoid tripping the
   site's anti-bot throttling), each with `pytest -n 2` for intra-suite
   parallelism and `--reruns 2 --reruns-delay 5` to absorb transient flakes;
2. merges the results into a single Allure report and publishes it to GitHub
   Pages (keeping the history trend);
3. posts a pass/fail summary with the report link to Slack.

Credentials and the Slack URL are stored as repository **secrets**, never in the
code: `TEST_USER_EMAIL`, `TEST_USER_PASSWORD`, `SLACK_WEBHOOK_URL`.

## Project structure

```
task.10/
├── pages/              one class per page of the site (Page Object Model)
│   ├── base_page.py    shared behaviour: open a page, dismiss the cookie banner
│   ├── components/     reusable parts (site header / navigation)
│   └── ...             login, signup, products, cart, checkout, payment, ...
├── utils/
│   ├── data_generator.py   random users / cards / text via Faker
│   └── allure_helpers.py   attach a screenshot to the report
├── tests/             one file per scenario (test_tcNN_*.py)
│   └── data/          static fixtures (e.g. the file used by the upload test)
├── conftest.py        pytest fixtures (browser setup, page objects, login)
├── pyproject.toml     pytest / Playwright / Allure configuration
└── requirements.txt   Python dependencies
```

## Configuration

| Variable | Used by | Where |
|----------|---------|-------|
| `TEST_USER_EMAIL` / `TEST_USER_PASSWORD` | TC‑02 login | `.env` locally, repo secrets in CI |
| `SLACK_WEBHOOK_URL` | CI Slack notification | repo secrets |

`.env` is git‑ignored; `.env.example` is the template to copy.
