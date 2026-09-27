# AI-assisted test automation: Claude Code vs Cursor (Playwright MCP) vs Cypress cy.prompt

[![Task 12 Playwright Tests](https://github.com/Hrehoryjj/LuxeQuality/actions/workflows/task12-playwright.yml/badge.svg)](https://github.com/Hrehoryjj/LuxeQuality/actions/workflows/task12-playwright.yml)

## TL;DR

**How each tool performed**
- **Claude Code + Playwright MCP** — its rules file actually loaded and it verified every locator
  through MCP; the later test cases (TC-06, TC-07, TC-08) passed on the first iteration with no manual
  fixes. In my setup it was the fastest route to tests I could trust.
- **Cursor + Playwright MCP** — its rules file was silently ignored because of a wrong file extension.
  The tests still passed, but with CSS/id locators checked via curl, weaker assertions and one skipped
  test-case step: plausible-looking code that broke the agreed rules.
- **Cypress `cy.prompt`** — quick to write in natural language, but it needed the most correction: an
  ambiguous phrase became a wrong URL assertion, its AI-evaluated checks were too vague to serve as the
  oracle, and in TC-06 its steps "completed" while a cookie-consent dialog blocked the action — caught
  only by a deterministic assertion.

This is not a controlled benchmark: Cursor ran with a broken rules file, and I used Claude Code for
the review and fixes.

**How I would use each**
- **Claude Code** — building and maintaining a framework under rules, multi-file changes, review and
  refactoring, CI setup.
- **Cursor** — interactive work in the IDE when I want to watch and steer every edit; small, targeted
  changes.
- **Cypress `cy.prompt`** — quick drafts and navigation steps in an existing Cypress project; never as
  the final oracle. Requires Cypress Cloud.

**What I would change next time**
- Run several agents in parallel, each in its own isolated folder, with explicit verification gates in
  the prompt: the agent quotes the rules before starting, and a test only counts as done after a
  negative control and a 10× stability run.
- Write the expected assertion into every test case, not only the steps, and make the agent log
  iterations and manual fixes after every run.

## Why this project

This is a hands-on comparison of three ways to get an AI to write browser test automation against
the same public demo e-commerce site, [automationexercise.com](https://automationexercise.com):

- **Claude Code + Playwright MCP** — `playwright-project/tests/claude-code/`
- **Cursor + Playwright MCP** — `playwright-project/tests/cursor/`
- **Cypress `cy.prompt`** (Cypress's own AI test-writing command) — `cypress-project/`

The point isn't to build a production suite for this site — it's to see, with real prompts, how
each tool behaves when asked to follow the same rules: discover locators live
instead of guessing, build page objects before specs, write specific assertions, and get to a
passing test with the fewest surprises. A reviewer should look at three things: whether the
locators and assertions in the code actually match what the live site does (not just whether the
test is green), how much of the process was genuinely AI-driven versus manually patched, and
whether the failure modes documented below are real (reproducible) or asserted.

## Test cases

| ID | Title | Type | Tool(s) | Status |
| --- | --- | --- | --- | --- |
| TC-01 | Register User | Positive | Claude Code | ✅ Passing |
| TC-02 | Login User with correct email and password | Positive | Claude Code | ✅ Passing |
| TC-03 | Verify All Products and product detail page | Positive | Cypress `cy.prompt` | ✅ Passing |
| TC-04 | Search Product | Positive | Cypress `cy.prompt` | ✅ Passing |
| TC-05 | Verify Subscription in home page | Positive | Cursor | ✅ Passing |
| TC-06 | Remove Products From Cart | Positive | Claude Code, Cursor, Cypress `cy.prompt` | ✅ Passing |
| TC-07 | Login with incorrect email or password | Negative | Claude Code, Cypress `cy.prompt` | ✅ Passing |
| TC-08 | Register with an already existing email | Negative | Claude Code | ✅ Passing |

## AI setup

**MCP configs** — both tools point at the same [`@playwright/mcp`](https://github.com/microsoft/playwright-mcp) server, run over stdio via `npx`:

- [`playwright-project/.mcp.json`](playwright-project/.mcp.json) — used by Claude Code
- [`playwright-project/.cursor/mcp.json`](playwright-project/.cursor/mcp.json) — used by Cursor

This is what makes "locator discovery via MCP" possible at all: instead of the agent guessing a
CSS selector from memory or from static HTML, it drives a real browser, takes an accessibility
snapshot, and reads back actual roles/names/attributes.

**Agent rules** — [`playwright-project/CLAUDE.md`](playwright-project/CLAUDE.md) (Claude Code) and
[`playwright-project/.cursor/rules/testing.mdc`](playwright-project/.cursor/rules/testing.mdc)
(Cursor) are near-identical rule sets, one per tool's own folder scope. What each rule enforces and
why:

| Rule | Enforces | Why |
| --- | --- | --- |
| 1. File interaction | Work confined to `tests/claude-code` or `tests/cursor` | Keeps the two tools' output from overwriting or reading each other's files |
| 2. POM | Page objects before specs, all locators/interactions live there | Specs stay readable as test *intent*; locator changes touch one file |
| 3. Spec files | Specs only in `specs/` | Predictable structure, easy to find |
| 4. MCP usage | Locators/navigation/assertions discovered via MCP, not guessed | Locators are checked against the real DOM, not remembered/hallucinated |
| 5. No stray specs | No `urltest_<uuid>.spec`-style files | Keeps the AI from scattering scratch files into the repo |
| 6. Naming | Consistent naming | Readability |
| 7. Locators | No locators cached in constructors; none in spec files | Avoids stale locators after DOM changes; keeps specs free of selector churn |
| 8. Assertions | `expect(...)`, never `console.log` | A test that only logs never fails |
| 9. Config | `baseURL` in config, relative `page.goto('/path')` in tests | Environment-portable tests |
| 10. Clean code | No commented-out code/debug statements | Committed code stays real code |
| 11. Scope exceptions | Project-level config files editable only when a prompt explicitly asks | Closes a real conflict: rule 1 said "don't touch files outside this folder" while I still needed to edit the root `playwright.config.ts` to set it up in the first place |

## Workflow: from prompt to passing test

For each test case, the loop was: **test case → prompt → MCP exploration → page objects → spec →
run → review → fix.** Concretely: the prompt names the test case and points at the rules file; the
agent drives the live site through MCP to find real locators and text before writing anything;
page objects are written first (rule 2); the spec is written against those page objects with
`expect(...)` assertions; `npx playwright test` (or `npx cypress run`) is run until green; the
diff is reviewed for rule violations (locators in specs, hardcoded waits, weak assertions) before
being accepted. Exact prompts, MCP findings, iteration counts and every manual fix are recorded in
[`prompts.md`](prompts.md) — that file is the primary evidence trail, this README summarizes it.

## How I verified the AI-generated tests

**Review checklist** applied to every spec before accepting it:
- Do the steps in the spec actually match the test case (not a paraphrase that skips a step)?
- Are the assertions specific — an exact name/text/count, not just "an element is visible"? (This
  is what caught TC-02's original "some 'Logged in as' text" oracle and TC-03/TC-04's original
  AI-evaluated oracles — see Findings.)
- Are all locators inside page objects, none in the spec file?
- No hardcoded waits (`waitForTimeout`, `cy.wait(<ms>)`) — only condition-based waits?

**Negative control** (proves the tests can actually fail, not just pass by accident): for each test
below I temporarily broke one expected value, ran the test alone, confirmed the failure, then
reverted the change (nothing broken was committed):

| Test | What was changed | Failed as expected | Failure message |
| --- | --- | --- | --- |
| TC-01 (Claude Code) | Appended `'BROKEN'` to the expected registered name | Yes | `Expected substring: "...BROKEN" Received string: " Logged in as ..."` |
| TC-02 (Claude Code) | Appended `'BROKEN'` to the expected logged-in name | Yes | `Expected substring: "...BROKEN" Received string: " Logged in as ..."` |
| TC-06 (Claude Code) | Changed the remaining-product assertion to expect `'BROKEN'` | Yes | `expect(locator).toContainText(expected) failed` |
| TC-06 (Cursor) | Swapped the final assertion's product id (2 → 1) | Yes | `element(s) not found` — the removed row's locator timed out |
| TC-08 (Claude Code) | Changed the "account creation not reached" assertion from `toHaveCount(0)` to `toHaveCount(1)` | Yes | `Expected: 1, Received: 0` |

**Stability** — I ran `npx playwright test --repeat-each=10 --retries=0` (70 runs: 7 specs × 10)
twice:

| Run | Workers | Result |
| --- | --- | --- |
| Before | 8 (default) | 66/70 passed (94.3%) — 4 isolated failures, one each in TC-01, TC-02, TC-07 (Claude Code) and TC-05 (Cursor); a heading timeout and one non-JSON API response |
| After | 3 (capped in `playwright.config.ts`) | 70/70 passed (100%), twice |

Root cause: 8 parallel browser sessions hammering the same single public demo instance
simultaneously — not test-code flakiness (no shared fixtures/state; TC-01/TC-02/TC-08 each create
and delete their own throwaway account). The fix was capping concurrency (`workers: 3`), not
retries — `retries` was changed from a flat `1` to `process.env.CI ? 1 : 0` specifically so a local
run can't silently retry away a real failure.

**Hybrid-oracle approach**: `cy.prompt` evaluates its own "verify" steps with an AI judgment call,
which is fine for "is this heading visible" but is the wrong tool for the actual pass/fail oracle —
an AI-evaluated assertion can be talked into passing on the wrong behaviour by a loosely worded
prompt (this happened twice, see Findings). So `cy.prompt` is used only for
navigation/simple visibility checks in TC-03, TC-04 and TC-06; every assertion that decides whether
the test caught a real bug is plain deterministic Cypress code reading real DOM state (e.g. TC-03
asserts the detail page's product name equals the name read from the list before navigating,
instead of just asserting a name is present).

## Comparison

| | Claude Code + MCP | Cursor + MCP | Cypress `cy.prompt` |
| --- | --- | --- | --- |
| Iterations to green | TC-01/TC-02: not tracked; TC-06, TC-07, TC-08: 1 each | ≥2 recorded (the first run failed on the consent overlay) | TC-03/TC-04: ≥2 recorded (the first run failed on prompt wording); TC-06: 3 real runs (failed on a consent dialog, then on a guessed URL, passed after both fixes) |
| Manual fixes | 0 (ad-overlay blocking was fixed proactively via an MCP-derived fixture, not a post-failure patch) | None — I did not edit the generated code | Three: two prompt re-wordings ("current page is X", "go to the cart page") and adding consent/ad host blocking to `support/e2e.ts` |
| Locator quality | Role/test-id/placeholder first (`data-qa` everywhere on forms), MCP-verified; CSS only for three cart elements with no accessible alternative (`.add-to-cart[data-product-id]` + `.first()`, `#product-<id>`, `.cart_quantity_delete[data-product-id]`), each justified in `prompts.md`'s TC-06 write-up | Discovered via curl instead of MCP throughout (a rule 4 violation on its own, applying to all 9 locators regardless of category). Of the 9 CSS/id locators: 4 (`#footer h2`, `#susbscribe_email`, `#header a[href="/view_cart"]`, `.close-modal`) had a real accessible alternative and used CSS anyway with no justification recorded; 3 (`#subscribe`, `.add-to-cart`, `.cart_quantity_delete`) are justified since the site exposes nothing better there; 1 (the subscribe success message) is a partial case — a `getByText` match would work but isn't on rule 4's preferred locator list; 1 (cart row by id) is a reasonable compromise for a row with no useful accessible name of its own — see `prompts.md` for the full locator table | N/A — `cy.prompt` resolves its own elements, no locators to review |
| Stability | 47/50 (94%) → 50/50 (100%) after capping `workers: 3` | 19/20 (95%) → 20/20 (100%) after the same `workers: 3` cap | Not measured with repeats (single confirmed runs only) |
| Assertion specificity | TC-06 checks the exact remaining product's name, not just that a row exists | TC-06 checks row visibility/count by id only, never a name; TC-05 has no "home page loaded" assertion before scrolling to the footer; `CartPage.goto()` is also unused dead code (kept as-is — see Limitations) | Deterministic assertions are the oracle for every test (see Hybrid-oracle approach) |
| External dependencies | None beyond the MCP server | None beyond the MCP server | Cypress Cloud account (`cy.prompt` requires it) |
| Test execution time | 15.8s for 5 specs (TC-01 5.0s, TC-02 2.7s, TC-06 4.0s, TC-07 2.4s, TC-08 1.7s), one run, `--workers=1` | 6.9s for 2 specs (TC-05 2.7s, TC-06 4.2s), same run | 27s for 4 specs (TC-03 7.1s, TC-04 7.8s, TC-06 7.5s, TC-07 5.3s), one run. Generation time (prompt to first draft) wasn't measured for any tool |
| When I'd use it | Building and maintaining a framework under rules, multi-file changes, review and refactoring, CI setup | Interactive work in the IDE when I want to watch and steer every edit; small, targeted changes | Quick drafts and navigation steps in an existing Cypress project; never as the final oracle. Requires Cypress Cloud |

## Findings

**Site issues** (all confirmed live, not assumed):
- A Google AdSense vignette and (in the Cursor run) a "Funding Choices" consent dialog intercept
  pointer events on Signup/Continue/Add-to-cart buttons — worked around with a fixture that blocks
  the ad-serving hosts before navigation.
- `<label for="city">Zipcode *</label>` — the "Zipcode" label is wired to the City input, not a
  Zipcode input; `getByLabel('Zipcode')` is unreliable there.
- `/login` renders two "Email Address" textboxes (login + signup forms) — an unscoped
  `getByPlaceholder('Email Address')` is ambiguous.
- Headings are visually uppercased by CSS only; the DOM text is mixed-case
  (`Enter Account Information`, `Account Created!`, …).
- The site's product search matches loosely — searching "Top" returns 14 products, 2 of which
  don't contain "Top" in their name.

**AI failure modes** (each one changed how a later test case was built):
- **Ignored rules file.** Cursor's rules lived at `.cursor/rules/testing.mcd` — Cursor only loads
  `.mdc` — so they were most likely never applied. Discovering every locator via curl instead of
  Playwright MCP violates rule 4 outright, regardless of what those locators turned out to be. The
  locators themselves are a mixed picture: some CSS was justified because the site exposes nothing
  better, and some used CSS where an accessible alternative existed, which is a second rule 4
  violation (see Locator quality above). Lesson: ask the agent to quote a rule back before trusting a
  rules-file-driven run.
- **`cy.prompt` URL misinterpretation.** A step like "verify the current page is the All Products
  page" was interpreted as a literal `cy.url().should('eq', 'All Products page')`, which can never
  pass. Rephrasing to reference visible text fixed it.
- **Vague AI oracle.** TC-03's original assertions checked that the detail page *has* a
  name/price/etc., not that it's the *right* product; TC-04's original assertion
  ("most of the displayed products are related…") could pass on a broken search. Both were
  replaced with deterministic assertions (see Hybrid-oracle approach above).
- **AI steps "completed" while something else blocked the actual result — twice.** My real
  `npx cypress run` on TC-06 failed with `Expected to find element: #product-1, but never found it`
  on two separate runs, for two different reasons: first a cookie-consent dialog blocked the
  add-to-cart click (fixed by blocking the consent host in Cypress, the same way both Playwright
  projects already did); then, after that fix, `cy.prompt`'s "go to the cart page" step guessed a
  `/cart` URL that doesn't exist on the site and got redirected to the homepage instead of clicking
  the actual "Cart" link — the same guessing-instead-of-acting failure mode as the "current page is
  X" bug above. In both cases `cy.prompt` reported success while the real state it depended on never
  happened; only the deterministic assertion after it caught the gap. Fixed by making the step name
  a concrete UI element ("click the Cart link in the header navigation") — see `prompts.md` for
  both fixes.
- **Weaker oracle when the rules file didn't load.** Beyond the locator choices above, Cursor's
  TC-06 asserts the removed row is gone and the other row is *visible*, but never checks *which*
  product that row actually is — a name swap would pass the same assertion. Cursor's TC-05 also has
  no assertion that the home page loaded before scrolling to the footer and reading the Subscription
  heading, unlike every other spec in this repo, which asserts on a landing heading first.

## Iteration history

**v1 — initial generation.** I asked each tool to build its slice: Claude Code got TC-01/TC-02,
Cursor got TC-05/TC-06, Cypress got TC-03/TC-04. Everything ran green, but a review turned up real
problems: Cursor's rules file had the wrong extension and never loaded, so its locators came from
curl instead of MCP; TC-02 depended on a shared seeded account and only checked that *some* "Logged
in as" text appeared; TC-03/TC-04 either asserted the wrong thing (that a product page has a name,
not that it's the *right* product) or used a vague AI-judged oracle that could pass on a broken
search; there was no negative test, no evidence any test could actually fail, and no CI.

**v2 — fixes.** I created a throwaway user via the site's own API for TC-02 (and later TC-08)
instead of relying on the shared account; rewrote TC-03/TC-04 as a hybrid of `cy.prompt` navigation
and deterministic assertions; added TC-06 to all three tools as a shared, apples-to-apples case;
added negative tests (TC-07, TC-08); ran a real negative control and a 10×-repeat stability check,
found and fixed a genuine concurrency issue against the public target site; and wired up CI.

**v3 — the real Cypress run.** Running the actual suite (not just reviewing the code) surfaced two
more bugs `cy.prompt` alone never would have caught: TC-06 first failed on a cookie-consent dialog
Cypress didn't block (Playwright already did), then failed again for an unrelated reason — a step
asking to "go to the cart page" made `cy.prompt` guess a URL that doesn't exist on the site. The
consent dialog is now blocked the same way Playwright blocks it, and the cart step now names a
concrete UI element instead of a destination. I also went back over the whole comparison for
consistency: fixed the locator-quality claims against what's actually accessible on the page
(checked live, not assumed), corrected the stability arithmetic, aligned TC-06's steps with the
written test case, and hardened the API helper to fail with a readable message instead of a raw
parse error. TC-01 also got an `afterEach` safety cleanup that deletes its account through the API
if a failed run left it behind, treating the API's `404 "Account not found!"` as already deleted.

## Lessons learned

1. Check that agent rules are actually loaded — ask the agent to quote a rule before it starts.
2. Put the expected assertion into every test case, not only the steps.
3. Make a negative control and a 10× stability run part of the Definition of Done.
4. Have the agent log iterations and manual fixes after every run.
5. Never depend on shared external state (e.g. a seeded account on a public site) — create and clean
   up test data via the API.
6. Give every tool the same test case from the start if the goal is a comparison.
7. Run agents in parallel only in isolated folders with their own rules.
8. AI-driven steps can "complete" without achieving their effect — the oracle must be deterministic.

## What I chose to automate and why

- **TC-06 as the shared case for all three tools** — it combines several actions (adding products,
  handling the confirmation modal, navigation, removal) and a state check, so it shows the
  differences between tools better than a single-step case.
- **Negative tests in Claude Code and Cypress, not in Cursor** — when I added them, Cursor was not
  available (plan usage limit).
- **TC-03 and TC-04 on Cypress `cy.prompt`** — it is a different approach from the other two
  (natural-language steps executed at runtime, no Page Object Model), and read-only navigation flows
  are a good fit to evaluate it.
- **Direct `/login` navigation for TC-01/02/07/08, but a header-link click for TC-06** — the written
  cases for TC-01/02/07/08 say "click Signup / Login", but that click isn't what those tests verify
  (they're about registration/login behavior, not header navigation), so I open `/login` directly.
  TC-06 clicks the header's Cart link instead, because reaching the cart by navigating the site *is*
  part of the flow that test is checking.

## Run locally

Every command below runs from `task.12/` and is exactly what `cypress-project/package.json` and the
CI workflow use.

```bash
# Playwright (Claude Code + Cursor specs)
(cd playwright-project && npm ci && npx playwright test)
(cd playwright-project && npm run test:claude)      # Claude Code specs only
(cd playwright-project && npm run test:cursor)      # Cursor specs only
(cd playwright-project && npm run test:stability)   # stability check
(cd playwright-project && npm run report)

# Cypress (cy.prompt specs)
(cd cypress-project && npm ci && npx cypress run)
# report: open cypress-project/cypress/reports/html/index.html
```

Before running the Cypress tests for the first time, log in to Cypress Cloud once
(`npx cypress open` and follow the prompt) — `cy.prompt` won't run without it.

The Cypress CI workflow (`.github/workflows/task12-cypress.yml`) is `workflow_dispatch`-only and
needs the `CYPRESS_RECORD_KEY` repository secret to run `cypress run --record`.

## Limitations

- automationexercise.com is a public demo site, not a real product — test data (accounts) is
  created and deleted through its own public API, and the site's behavior (loose search, ad
  overlays) is outside this project's control.
- `cy.prompt` requires a linked Cypress Cloud project; there's no fully offline way to run the
  Cypress suite.
- The cookie-consent dialog that caused TC-06's first Cypress failure didn't show up on every visit
  in my testing — it may depend on the visitor's region (it appeared for me in Poland). The fix
  blocks its known hosts regardless of whether the dialog renders.
- TC-06's assertions are tied to specific catalog entries (product ids 1 and 2, named "Blue Top" and
  "Men Tshirt") — if the site's catalog changes, the test breaks on a mismatch, not a real bug.
- The site is a single public instance with real capacity limits — running many tests in parallel
  against it caused real failures until I capped Playwright's `workers` (see Stability); the same
  ceiling applies to anything else that hits it concurrently.
- Cursor's tests are exactly as they came out of the run where its rules file didn't load — I chose
  not to regenerate them, partly to keep them as evidence for that finding and partly because Cursor
  wasn't available to me at the time (plan usage limit).
- This project stops at 8 test cases across three tools — it's a comparison exercise, not
  full coverage of the site.
