# Telnyx.com — E2E Test Suite (WebdriverIO)

## Summary

End-to-end browser test suite for [telnyx.com](https://telnyx.com), built with WebdriverIO and TypeScript. The suite covers 20 test cases across home page, header navigation, pricing, footer, and the contact form, following the Page Object Model (POM): each page's selectors are defined as private static constants and exposed only through action/assertion methods in `test/pageobjects/`, while test files in `test/specs/` only call those methods and assert on results — no raw selectors inside spec files.

If you're not a tester: this project is a set of scripts that open telnyx.com in a real Chrome browser and click through it the way a user would — checking that the logo links home, the footer links aren't broken, the contact form accepts input, and so on. Running it locally, in Docker, or in CI tells you, in a couple of minutes, whether something on the site changed in a way that broke a core interaction.

## Tech stack

- **WebdriverIO** `^9.30.1` (`@wdio/cli`, `@wdio/local-runner`, `@wdio/mocha-framework`)
- **TypeScript** `^7.0.2`
- **Mocha** (test framework, via `@wdio/mocha-framework`)
- **Allure** (`@wdio/allure-reporter` + `allure-commandline`) for HTML test reports
- **@faker-js/faker** for random test data, combined with a fixed known-valid record (`test/data/users.json`) for fields that need a stable, realistic value (phone, email)
- Node.js `v22.23.2` (tested version; any Node 18+ should work)
- **Docker** for running the suite in an isolated, reproducible environment (same image used locally and in CI)

## Requirements

- Node.js 18 or newer
- npm 10 or newer
- Docker (for containerized runs)
- Google Chrome installed locally (only needed for running outside Docker)
- Git

## Install

```bash
git clone <repository-url>
cd task.7
npm install
```

`npm install` reads `.npmrc` (`legacy-peer-deps=true`), which is required — some WebdriverIO peer dependency ranges conflict under npm's default strict resolver.

## Configs

The WebdriverIO configuration is split into three files:

- **`wdio.shared.conf.ts`** — settings common to every run: specs glob, framework, timeouts, reporters, the `afterTest` screenshot hook, `specFileRetries`.
- **`wdio.local.conf.ts`** — extends the shared config, adds Chrome capabilities for running on a developer machine (headless, no container-specific sandbox flags).
- **`wdio.ci.conf.ts`** — extends the shared config, adds the extra Chrome flags required in a containerized environment (`--no-sandbox`, `--disable-dev-shm-usage`, `--disable-setuid-sandbox`), used both by Docker and by GitHub Actions.

## Run tests locally (without Docker)

```bash
npm run test:local
```

This runs all specs in `test/specs/**/*.ts` against telnyx.com in headless Chrome (1920×1080 window). `baseUrl` is set to `https://telnyx.com`, so specs navigate with relative paths (`/pricing`, `/contact-us`, etc.).

To run a single spec file:
```bash
npm run test:file -- test/specs/pricing.e2e.ts
```

## Run tests in Docker

Build the image and run the suite inside it — this is the same image the CI pipeline uses:

```bash
docker build -t telnyx-tests .
docker run --rm -v $(pwd)/allure-results:/app/allure-results telnyx-tests
```

The volume mount copies the Allure results out of the container so they're available on the host afterward for report generation. The container runs `npm run test:ci`, using `wdio.ci.conf.ts`.

## Generate the Allure report

Test runs write raw results to `allure-results/`. To turn that into a browsable HTML report:

```bash
npm run report:generate
npm run report:open
```

The first command builds the report folder, the second serves it locally and opens it in your default browser.

## CI/CD (GitHub Actions)

`.github/workflows/tests.yml` runs on every push and pull request:

1. Checks out the repo
2. Builds the Docker image from `task.7/Dockerfile`
3. Runs the tests inside that container (headless Chrome, `wdio.ci.conf.ts`)
4. On failure, uploads any saved screenshots (`errorShots/`) as a workflow artifact
5. Installs the Allure CLI and generates the HTML report
6. Publishes the report to the `gh-pages` branch via `peaceiris/actions-gh-pages`

Once GitHub Pages is enabled for the repo (**Settings → Pages → Source: `gh-pages` branch**), the latest report is viewable at `https://<username>.github.io/<repo>/` without downloading anything — useful for checking a run's result from a phone or a machine that doesn't have the project cloned.

## Project structure

```
task.7/
├── test/
│   ├── pageobjects/      — one class per page/section; every selector is a
│   │                         private static readonly constant, only action/
│   │                         assertion methods are public
│   ├── specs/             — test files, grouped by area (home, navigation,
│   │                         pricing, footer, contact-us)
│   ├── data/               — known valid test data (users.json)
│   └── utils/               — random data generation (randomData.ts)
├── wdio.shared.conf.ts     — base WebdriverIO config
├── wdio.local.conf.ts      — local-run Chrome capabilities
├── wdio.ci.conf.ts         — CI/Docker Chrome capabilities
├── Dockerfile               — Node 22 + Chrome image used locally and in CI
├── .dockerignore
├── tsconfig.json
├── .npmrc                   — legacy-peer-deps=true (required for install)
└── package.json
```

## Known limitations

- Currently configured for Chrome only. Firefox and Edge configs are planned but not yet implemented.
- The LEGAL footer links test (TC-12) accepts both `200` and `403` responses — Telnyx's server occasionally returns `403` to automated `fetch()` requests (bot protection), which is not a real broken-link condition; the test title reflects this.
- TC-20 (cookie settings) passes even when the OneTrust consent widget isn't shown — this depends on the region/IP OneTrust detects for the session and isn't something the test controls. When the widget is present, TC-20 does verify the settings panel opens correctly; when it's absent, the Allure report shows this explicitly in the test's description.