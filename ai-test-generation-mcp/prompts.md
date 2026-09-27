# Prompts

## Cursor + Playwright MCP

### Prompt

> Implement the Playwright test cases below for https://automationexercise.com, following
> .cursor/rules/testing.mcd exactly — locators derived only via the Playwright MCP server, page
> objects created before specs, everything confined to tests/cursor/. TC-05 Verify Subscription in
> home page (scroll to footer, verify "SUBSCRIPTION", enter email, click arrow button, verify
> success message) and TC-06 Remove Products From Cart (add products to cart, open cart page,
> remove one product via its "X" button, verify it's gone).

### Locators (verified via curl against live HTML + `cart.js`)

- Footer subscription heading: `#footer h2` (text "Subscription", CSS-uppercased on screen)
- Email input: `#susbscribe_email` — genuine typo in the site's own id ("susbscribe")
- Submit button: `#subscribe`
- Success message: `#success-subscribe .alert-success`, hidden until a successful subscribe
- Cart nav link: `#header a[href="/view_cart"]` — **must be scoped to `#header`**; an unscoped
  `a[href="/view_cart"]` also matches the "View Cart" link inside the add-to-cart confirmation
  modal (`#cartModal`), which stays in the DOM even when hidden, causing a Playwright strict-mode
  violation
- Add to cart: `.add-to-cart[data-product-id]`, confirmed via `cart.js`:
  `$('.add-to-cart').on('click', ...)`
- Modal dismiss ("Continue Shopping"): `.close-modal`
- Cart row: `#product-<id>`, confirmed via `cart.js`'s delete handler:
  `document.getElementById('product-' + product).remove()`
- Remove/"X" button: `.cart_quantity_delete[data-product-id]`, confirmed via `cart.js`:
  `$('.cart_quantity_delete').on('click', ...)`

### Finding: a cookie-consent overlay blocks clicks

Google's "Funding Choices" consent dialog (`div.fc-consent-root`, `div.fc-dialog-overlay`)
intercepted pointer events on the Add to Cart buttons on first run, causing both specs to fail
with pointer-event-interception errors. Fixed the same way TC-01/TC-02 handled their ad overlay:
an auto-use fixture (`tests/cursor/fixtures/test.ts`) that routes and aborts requests to
`fundingchoicesmessages.google.com` (plus the same ad hosts already blocked in the
`tests/claude-code/` fixture) before navigation, so the dialog never renders.

### Result

`npx playwright test tests/cursor` — 2 passed, run twice in a row to confirm repeatability (no
leftover cart/subscription state between runs).

### Shared case: TC-06 Remove Products From Cart

TC-06 above is also the case I implemented identically in `tests/claude-code/` and in Cypress,
to make the three-tool comparison apples-to-apples. Number of iterations until green and any manual
fixes for this Cursor run: ≥2 recorded (the first run failed on the consent overlay); manual fixes
by me: none.

### Finding: the rules file was silently ignored

The prompt above points at `.cursor/rules/testing.mcd` — but Cursor only loads rule files with the
`.mdc` extension. `.mcd` is not a format Cursor recognizes, so this rules file was most likely
never loaded for the run that produced `tests/cursor/`, despite the prompt naming it explicitly.

Evidence, from the code that came out of that run: every locator was verified via curl against live
HTML + `cart.js` (see "Locators" above), although rule 4 requires discovery through Playwright MCP —
that alone is a rule violation regardless of which locators it produced. But the locators themselves
are a mixed picture, not uniformly bad. Checked each one live via MCP for whether an accessible
(role/label/placeholder/test-id) alternative actually exists:

| Locator | Used in | Accessible alternative? |
| --- | --- | --- |
| `#footer h2` | `HomePage.ts` | Yes — `getByRole('heading', {name: 'Subscription'})`; confirmed the only `<h2>` with that text on the page |
| `#susbscribe_email` | `HomePage.ts` | Yes — `getByPlaceholder('Your email address')` |
| `#subscribe` | `HomePage.ts` | No — icon-only `<button>`, no text/aria-label of any kind |
| `#success-subscribe .alert-success` | `HomePage.ts` | Partial — the text is unique in the DOM (`getByText('You have been successfully subscribed!')` would work, matching the precedent `BasePage.getLoggedInAsLabel()` already sets elsewhere in this repo), but "match by visible text" isn't on rule 4's preferred locator list |
| `#header a[href="/view_cart"]` | `CartPage.ts` | Yes, with a caveat — a naive `getByRole('link', {name: 'Cart', exact: true})` actually times out: the link's icon (`<i class="fa fa-shopping-cart">`) exposes its CSS icon-font glyph to the accessibility tree, so the real accessible name isn't the literal string "Cart". Scoping to the page's `banner` landmark first (`getByRole('banner').getByRole('link', {name: 'Cart'})`, non-exact) does work and is unambiguous, since the add-to-cart modal's "View Cart" link lives outside the banner |
| `.add-to-cart[data-product-id]` | `ProductsPage.ts` | No — generic clickable element, no role or accessible name |
| `#cartModal.show .close-modal` | `ProductsPage.ts` | Yes — `getByRole('button', {name: 'Continue Shopping'})`; this is a real button with real text |
| `#product-<id>` | `CartPage.ts` | Borderline — the cart is a native `<table>`, so each row does get an implicit `row` role, and its accessible name would include the product name, but that name is the concatenation of every cell in the row (image, description, price, quantity input, total), so an exact role/name match is impractical; scoping by id and asserting on visible text is a reasonable compromise, not the same kind of miss as the other cases |
| `.cart_quantity_delete[data-product-id]` | `CartPage.ts` | No — icon-only `<a>`, no accessible name |

So the real story isn't "all CSS, therefore all wrong": `#subscribe`, `.add-to-cart` and
`.cart_quantity_delete` land on CSS because the site genuinely exposes nothing better there, and
`#product-<id>` is a reasonable practical compromise for a row with no useful accessible name of its
own — none of those four violate rule 4's locator-preference guidance. The success message is a
partial case. But `#footer h2`, `#susbscribe_email`, `#header a[href="/view_cart"]` and
`#cartModal .close-modal` each had a real accessible alternative and used CSS anyway, with no
comment or note explaining why — that's a second rule 4 violation (CSS over an available accessible
locator), on top of the rule 4 violation (curl instead of MCP for discovery) that applies to all
nine locators regardless of which category they fall into.

Lesson: a rules file silently not loading is not a loud failure — the agent just falls back to its
own judgment and produces code that looks plausible but violates the rules nobody checked were
active. Before trusting an agent's output against a rules file, ask the agent to quote a specific
rule back before it starts — if it can't, the rules aren't loaded.

Decision: `tests/cursor/` was deliberately **not** regenerated after the fix. TC-05 and TC-06
above are kept exactly as they were produced under the broken `.mcd` rules file, so they remain
the evidence for this finding — CSS/id locators, curl-based verification, and all. Only the
non-functional file issues around them (rules file extension, missing trailing newlines in
`.cursor/mcp.json` / `testing.mdc`) were fixed; the tests themselves still pass unchanged
(`npx playwright test tests/cursor` — 2 passed).

## Claude Code + Playwright MCP

### Prompt

> Implement two Playwright test cases for automationexercise.com per the rules in CLAUDE.md (this
> project's root). Follow it exactly: locators discovered only via the Playwright MCP server, POM files
> before specs, everything confined to `tests/claude-code/`. Set up `playwright.config.ts` (baseURL,
> testDir, testMatch limited to specs, HTML reporter, trace on first retry) and `tsconfig.json` (ES2022,
> bundler resolution, strict). Implement TC-01 Register User (register + verify + delete account) and
> TC-02 Login User with correct email/password (login with the seeded `test@te.si` / `Test1234!` account),
> using MCP to derive every locator, building page objects first, then specs with `expect(...)`
> assertions, then running `npx playwright test` until green.

### MCP-derived findings

- **Ad overlay blocks clicks.** A Google AdSense vignette (`iframe[id^=aswift]` inside
  `ins.adsbygoogle`) intercepts pointer events on `Signup` and `Continue` buttons. Fixed with an
  auto-use Playwright fixture (`tests/claude-code/fixtures/test.ts`) that routes and aborts requests to
  the ad-serving hosts before any navigation, so the overlay never loads.
- **Broken label wiring.** `<label for="city">Zipcode *</label>` — the "Zipcode" label actually points at
  the City input. `getByLabel('Zipcode')`/`getByLabel('City')` are unreliable for that field.
- **Duplicate placeholder text.** `/login` renders two "Email Address" textboxes (login form + signup
  form), so an unscoped `getByPlaceholder('Email Address')` is ambiguous.
- **Headings are uppercased by CSS only** — DOM text is `Enter Account Information`,
  `Account Created!`, `Account Deleted!`; assertions use case-insensitive regexes rather than the
  all-caps text a screenshot shows.
- **Every form field exposes a stable `data-qa` attribute** (e.g. `signup-name`, `login-email`,
  `create-account`, `account-created`, `continue-button`). Configured
  `testIdAttribute: 'data-qa'` in `playwright.config.ts` and used `getByTestId(...)` for all form
  fields/buttons in the page objects; role/heading/link locators cover everything else (nav links,
  headings, checkboxes/radios).
- Locators for `Account Created!`, `Account Deleted!`, and `Continue` (`data-qa="account-created"`,
  `"account-deleted"`, `"continue-button"`) were confirmed by driving a real signup → delete cycle
  through MCP before writing the page objects.

### Deviation from the written spec

TC-02 as written ends with **Delete Account**, but the only seeded credentials
(`test@te.si` / `Test1234!`) are shared/fixed, so deleting that account on the first run would break
every subsequent run. I decided to implement TC-02 as **login-only** against the seeded account:
"Login to your account" heading, log in, assert "Logged in as ..." — no delete step.

That still left a weak oracle (the assertion would pass even if the wrong account logged in) and a
dependency on a shared account on a public site anyone can delete. I later fixed this: TC-02 now uses
a `registeredUser` fixture (`tests/claude-code/fixtures/test.ts`) that creates a throwaway user
through the site's own `POST /api/createAccount` before the test and deletes it through
`DELETE /api/deleteAccount` after, via a small helper (`tests/claude-code/api/userApi.ts`). Both
endpoints were confirmed with `curl` first: HTTP 200 with a JSON body carrying `responseCode`
(`201` create / `200` delete) and a `message`, asserted with `expect(...)` so a broken fixture fails
loudly instead of silently. The spec then asserts `Logged in as <exact generated name>`, not just
that some "Logged in as" text is visible — confirmed against the live "Logged in as <b>Name</b>"
markup via MCP first. `existingUserCredentials` was removed from `testData/userData.ts` since
nothing uses it anymore. TC-01 is unaffected — it already registered and deleted its own account.

TC-01 still deletes its account through the UI as its last step, so a failure before that step would
leave a throwaway account behind. To guard against that, `register-user.spec.ts` added a
`test.afterEach` that calls a new `deleteUserIfExists()` (`tests/claude-code/api/userApi.ts`). It
hits the same `DELETE /api/deleteAccount` endpoint and treats `responseCode: 404` as already deleted
— the normal case when the test passes and the UI step already removed the account — while still
asserting `200` for any other response. Confirmed via curl for a nonexistent account: HTTP 200,
`Content-Type: text/html; charset=utf-8`, body `{"responseCode": 404, "message": "Account not
found!"}`.

### Result

`npx playwright test tests/claude-code` — 2 passed, run twice in a row to confirm repeatability (no
leftover accounts: both TC-01 and TC-02 now create and delete their own user via the API).

### Shared case: TC-06 Remove Products From Cart

Instructions followed: implement the same TC-06 case that already exists in `tests/cursor/`
(add two products to the cart, open the cart, remove one via its "X" button, verify the removed
product is gone and the other remains), in `tests/claude-code/`, deriving every locator via
Playwright MCP and following CLAUDE.md.

MCP exploration of `/products`, the "Added!" confirmation modal, and `/view_cart` confirmed:
`.add-to-cart[data-product-id]` (two DOM matches per product — one visible, one in the hover
overlay — hence `.first()`), the modal's `Continue Shopping` button has an accessible role/name
(`getByRole('button', { name: 'Continue Shopping' })`, unlike the "Add to cart" links which expose
no role/name), `#product-<id>` cart rows contain the product name in an `<h4><a>` (e.g. `Blue Top`,
`Men Tshirt` for products 1/2), and `.cart_quantity_delete[data-product-id]` removes a row. New page
objects: `pageObjects/ProductsPage.ts`, `pageObjects/CartPage.ts`; spec:
`specs/remove-from-cart.spec.ts`, asserting the removed row's product name is gone
(`toHaveCount(0)`) and the remaining row's exact product name is still present
(`toContainText('Men Tshirt')`) — not just an id count.

Iterations until green: 1 (single write-and-run cycle, no manual fixes). Result:
`npx playwright test tests/claude-code/specs/remove-from-cart.spec.ts` — 1 passed.

Later revisited to match the test case's literal step ("click the Cart button") instead of
navigating straight to `/view_cart`: added `clickCartLink()`. Validated the locator live via MCP
before writing it into the page object, per rule 4 — a naive
`getByRole('link', { name: 'Cart', exact: true })` timed out when tried: the header's cart link has
an icon (`<i class="fa fa-shopping-cart">`) whose CSS icon-font glyph gets exposed to the
accessibility tree, so its real accessible name isn't the literal string "Cart". Scoping to the
page's `banner` landmark first, `getByRole('banner').getByRole('link', { name: 'Cart' })`
(non-exact), resolved correctly and stays unambiguous against the add-to-cart modal's "View Cart"
link, which lives outside the banner. This was MCP-side locator discovery before the spec was
written, not a failed test run — once the validated locator went in, the spec still only needed the
one write-and-run cycle noted above. The method now lives on `BasePage` rather than `CartPage`,
since the header nav (and the Cart link in it) is available from any page, not just the cart page —
`remove-from-cart.spec.ts` calls it as `productsPage.clickCartLink()`, while still on the products
page.

### TC-07 Login with incorrect email/password

Confirmed the exact error text live via MCP: submitting a non-existent email/password on `/login`
renders `<p style="color: red;">Your email or password is incorrect!</p>` inside the login form
(no id/class on the paragraph, so `LoginPage.getLoginErrorMessage()` scopes to the form containing
`data-qa="login-password"` and matches that text). Spec `specs/login-invalid.spec.ts` asserts the
error is visible and `getLoggedInAsLabel()` has zero matches. 1 iteration, no manual fixes.
`npx playwright test tests/claude-code/specs/login-invalid.spec.ts` — 1 passed.

### TC-08 Register with an already existing email

Confirmed the exact error text live via MCP: signing up with an email that already has an account
renders `Email Address already exist!` inside the signup form (`LoginPage.getSignupErrorMessage()`,
scoped to the form containing `data-qa="signup-email"`). Spec
`specs/register-existing-email.spec.ts` uses the `registeredUser` fixture (introduced for TC-02) to create its
own throwaway user (cleaned up afterward by the same fixture), then attempts to sign up again with
that user's email and asserts the error is visible. 1 iteration, no manual fixes.

The test's title promises "does not create a second account", but the original version only checked
the error message, not that account creation was actually skipped. Confirmed via MCP: after the
failed signup, the URL stays on `/signup` and the "Enter Account Information" heading never
appears — added `expect(signupPage.getAccountInformationHeading()).toHaveCount(0)` so the test
actually verifies its own title. Negative-controlled by flipping that assertion to `toHaveCount(1)`,
confirmed it failed (`Expected: 1, Received: 0`), then reverted.

`npx playwright test tests/claude-code/specs/register-existing-email.spec.ts` — 1 passed.

## Cypress cy.prompt

All four Cypress specs (TC-03, TC-04, TC-06 and TC-07) are driven by `cy.prompt`, Cypress's AI
natural-language command. Requires
Cypress 15.4.0+ and a linked Cypress Cloud project — the project was upgraded from 13.17.0 to
15.21.1 and a Cloud project connected (`projectId: 'wrecjm'` in `cypress.config.ts`). No Page
Object Model is used here: `cy.prompt` resolves elements itself from the natural-language
description, so there's nothing for a POM layer to wrap.

### Hybrid approach: AI for navigation, deterministic code for the oracle

`cy.prompt` evaluates its own "verify" steps with an AI judgment call, not a fixed assertion. That
is fine for steps like "the heading text is visible" where there's one obvious right answer, but it
is the wrong tool for the actual pass/fail oracle of a test: an AI-evaluated assertion can be talked
into passing on the wrong behaviour by a loosely worded prompt (see the two findings below — both
are exactly that failure mode). So `cy.prompt` is used only for navigation and
simple visibility checks; every assertion that actually decides whether the test caught a real bug
is plain deterministic Cypress code (`cy.get(...).should(...)`) reading real DOM state.

### TC-03 Verify All Products and product detail page — [`view-all-products.cy.ts`](cypress-project/cypress/e2e/view-all-products.cy.ts)

Originally asserted that the detail page *has* a name/category/price/etc., which would pass even if
clicking "View Product" opened the wrong product. Fixed by reading the first product's name with
plain Cypress before navigating, then asserting the detail page's `<h2>` equals that exact name
(verbatim from `view-all-products.cy.ts`):

```ts
cy.get('.product-image-wrapper .productinfo p')
  .first()
  .invoke('text')
  .then((firstProductName) => {
    cy.wrap(firstProductName).as('firstProductName');
  });

cy.prompt(['click the View Product link on the first product in the list']);

cy.get('@firstProductName').then((firstProductName) => {
  cy.get('.product-information h2').should('have.text', firstProductName);
});
```

### TC-04 Search Product — [`search-product.cy.ts`](cypress-project/cypress/e2e/search-product.cy.ts)

Originally used a vague AI oracle ("verify most of the displayed products are related to ...")
that could pass even with a broken search. Replaced with two deterministic assertions: the result
set is non-empty, and it contains a specific product name confirmed live to contain "Top"
(`Blue Top`, product id 1):

```ts
cy.get('.product-image-wrapper .productinfo p').should('have.length.greaterThan', 0);
cy.contains('.product-image-wrapper .productinfo p', 'Blue Top').should('be.visible');
```

### Finding: the site's search is not a strict name-substring match

Searching "Top" returns 14 products (confirmed live via MCP), but 2 of them ("Little Girls Mr.
Panda Shirt", "Colour Blocked Shirt – Sky Blue") don't contain "Top" in their name — the site's
search matches loosely (likely across category/other fields too). The original TC-04 prompt worked
around this with a vague AI oracle ("most of the displayed products", "allowing for the site's known
loose/fuzzy search matching"); that oracle is gone now (see "Hybrid approach" above) and the
loose-search behaviour is documented here instead of baked into a prompt or a code comment. The
replacement assertion (`have.length.greaterThan(0)` + one confirmed matching name) doesn't need to
know about the loose matches at all.

### Finding: ambiguous prompt phrasing produces wrong assertions

First attempt used `'verify the current page is the All Products page'` / `'...Searched Products
page'` as a step. The AI interpreted "current page is X" as a literal `cy.url().should('eq', 'X')`
string-equality check against the URL — which obviously never equals a page name — failing both
specs. Rephrased to reference visible text instead of the ambiguous "current page" phrasing
(`'verify the page heading text "All Products" is visible'`), which fixed both.

### Result

`npx cypress run`: `view-all-products.cy.ts` (TC-03) and `search-product.cy.ts` (TC-04) have passed
on every run — 12 s/11 s, then 8 s/11 s, then 7.1 s/7.8 s in the latest full-suite run (normal
run-to-run variance, always green). Every selector and piece of product data used in the
deterministic assertions (`.product-image-wrapper .productinfo p`, `.product-information h2`,
`Blue Top`, "Searched Products" heading) was confirmed live via Playwright MCP before it went into
the spec.

### Shared case: TC-06 Remove Products From Cart — [remove-from-cart.cy.ts](cypress-project/cypress/e2e/remove-from-cart.cy.ts)

Same hybrid approach as TC-03/TC-04: `cy.prompt` drives adding two products to the cart and
navigating there, deterministic Cypress code is the oracle. Confirmed via MCP that the cart page
renders each product as `<tr id="product-<id>">` containing an `<h4><a>` with the exact product
name (`Blue Top` for product 1, `Men Tshirt` for product 2), so the assertions check by name, not
just by id count:

```ts
cy.get('#product-1').should('contain.text', 'Blue Top');
cy.get('#product-2').should('contain.text', 'Men Tshirt');
// cy.prompt removes the first product from the cart
cy.get('#product-1').should('not.exist');
cy.get('#product-2').should('contain.text', 'Men Tshirt');
```

### Finding: the AI steps completed while something else blocked the actual result — twice

**Run 1.** My real `npx cypress run`: TC-03 passed, TC-04 passed, TC-06 failed —
`Expected to find element: #product-1, but never found it` — and the failure screenshot showed a
cookie-consent dialog on screen. The `cy.prompt` steps reported as completed (add to cart, dismiss
the confirmation, go to the cart) even though the consent dialog was blocking the click that was
supposed to add the first product, so the product was never added and the cart page never had a
`#product-1` row.

Root cause: both Playwright projects already block ad/consent hosts in their fixtures
([claude-code](playwright-project/tests/claude-code/fixtures/test.ts),
[cursor](playwright-project/tests/cursor/fixtures/test.ts), including
`fundingchoicesmessages.google.com`) — the Cypress project blocked nothing. Confirmed via MCP that
`fundingchoicesmessages.google.com` traffic is active on `/products` (the dialog itself is
geography-dependent — see Limitations in the README). Fixed at the root, the same way Playwright
already does it: [cypress/support/e2e.ts](cypress-project/cypress/support/e2e.ts) got a global
`beforeEach` that intercepts requests to the same host list and destroys them with
`cy.intercept(...)`, so the dialog never renders.

**Run 2, after that fix.** I ran `npx cypress run` again: TC-07, TC-03 and TC-04 all passed, but
**TC-06 failed the exact same way** — `#product-1` still never found. This time the failure
screenshot had no consent dialog. The command log explained it: a step
`Prompt Step go to the cart page` had run as `visit /cart -> 302: https://automationexercise.com/`.
The site has no `/cart` route — `cy.prompt` guessed that URL for "go to the cart page" and got
redirected straight back to the homepage, so `#product-1` was never going to be there regardless of
whether the products were actually added. This is the same failure mode as "ambiguous prompt
phrasing produces wrong assertions" above: `cy.prompt` will guess a URL or action instead of using a
concrete UI element when the step text leaves it room to.

In both runs, `cy.prompt` had no way to know its own step hadn't achieved what it described; only
the deterministic assertion after it caught that the state it depended on never happened.

Fixed by replacing the step with a concrete UI action:
[`remove-from-cart.cy.ts`](cypress-project/cypress/e2e/remove-from-cart.cy.ts) now says
`'click the "Cart" link in the header navigation'` instead of `'go to the cart page'` — matching
what Cursor's Playwright version already does (`#header a[href="/view_cart"]`). `cy.prompt` is
natural language, not a role/name lookup, so this isn't an accessible-name match the way a
Playwright `getByRole` call would be — it works because the step now names a concrete, visible
element ("the Cart link in the header navigation") instead of an abstract destination ("the cart
page"), leaving `cy.prompt` nothing to guess. No assertion in any spec was weakened in either fix.

**Run 3, after both fixes.** `npx cypress run` — TC-06 passed in 7.5 s. 3 real runs to green for this
test: consent dialog, then a guessed URL, then passing once both were fixed at the root.

### TC-07 Login with incorrect email or password — [login-invalid.cy.ts](cypress-project/cypress/e2e/login-invalid.cy.ts)

Same hybrid approach: `cy.prompt` types a non-existent email and a wrong password into the login
form specifically (the page has two forms, login and signup — the same ambiguity already documented
for Playwright) and clicks Login. Confirmed via MCP that the exact error text
`Your email or password is incorrect!` renders inside the same `<form>` as the password field, with
no id/class of its own, so the assertion scopes to that form:

```ts
cy.get('[data-qa="login-password"]')
  .parents('form')
  .should('contain.text', 'Your email or password is incorrect!');
cy.contains(/Logged in as/i).should('not.exist');
```

`npx cypress run`: passed on every run — 20 s the first time, 4 s, then 5.3 s in the latest
full-suite run.

## Negative control

For each test below, one expected value was temporarily changed, the test was run alone, the
failure was confirmed, and the change was reverted (`git diff --quiet` confirmed a clean tree after
each revert — none of this was committed).

| Test | What was changed | Failed as expected | Failure message |
| --- | --- | --- | --- |
| TC-01 (claude-code) | Appended `'BROKEN'` to the expected name in `toContainText(user.name)` | Yes | `Expected substring: "QA Tester …BROKEN" Received string: " Logged in as QA Tester …"` |
| TC-02 (claude-code) | Appended `'BROKEN'` to the expected name in `toContainText(registeredUser.name)` | Yes | `Expected substring: "QA Tester …BROKEN" Received string: " Logged in as QA Tester …"` |
| TC-06 (claude-code) | Changed the remaining-product assertion to `toContainText('BROKEN')` | Yes | `expect(locator).toContainText(expected) failed` — received `"…Rs. 400…"` instead of `"BROKEN"` |
| TC-06 (cursor) | Changed the last assertion's product id from `2` to `1` (asserts the removed product is still visible) | Yes | `Error: element(s) not found` — `locator('#product-1')` timed out waiting to be visible |
| TC-08 (claude-code) | Changed the "account creation not reached" assertion from `toHaveCount(0)` to `toHaveCount(1)` | Yes | `Expected: 1, Received: 0` — the "Enter Account Information" heading never appears |

## Stability

`npx playwright test --repeat-each=10 --retries=0` (70 runs: 7 specs × 10) was run twice.

**Before** (default config, 8 parallel workers): 66/70 passed (94.3%) overall — Claude Code
(5 specs × 10 = 50 runs): 47/50 (94%), one failure each in TC-01, TC-02, TC-07; Cursor
(2 specs × 10 = 20 runs): 19/20 (95%), one failure in TC-05. Never the same spec twice, and never on
the same repeat number. Failure modes: a heading not appearing within the 10s expect timeout, and one
`deleteAccount` call getting back an HTML error page instead of JSON
(`SyntaxError: Unexpected token '<', "<h2>This w"...`). Investigated root cause: this is a single
public demo instance under `fullyParallel: true` with the default (CPU-count) worker pool — 8
browser contexts hitting the same free site simultaneously in a tight loop is enough to make it
occasionally respond slowly or with an error page. This is not test-code flakiness (no shared
fixtures/state was involved — TC-01/TC-02/TC-08 each use their own throwaway account) and retries
would only have hidden it.

**Fix:** capped `workers: 3` in `playwright.config.ts` (root cause fix — less concurrent load on the
shared target — not a retry). Re-ran twice after the fix: **70/70 passed (100%) both times.**

Also changed `retries` to `process.env.CI ? 1 : 0` (was a flat `1`) so a local run never silently
retries away a real failure; CI keeps one retry as a safety net against the same public-site
capacity limits under whatever concurrency GitHub Actions runners allow.

## Negative tests (claude-code and Cypress)

TC-07 exists in both `tests/claude-code/` and Cypress (`login-invalid.cy.ts`, above). TC-08 has no
Cursor/Cypress counterpart — it was only required in `tests/claude-code/`. See "TC-07 Login with
incorrect email/password" and "TC-08 Register with an already existing email" under the Claude Code
section above.
