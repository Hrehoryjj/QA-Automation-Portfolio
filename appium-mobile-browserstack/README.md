# Mobile Automation on BrowserStack + WebdriverIO (task.8)

## What this project does

This project automatically tests the **Android-NativeDemoApp** mobile application.
Instead of a person manually tapping through the app on a phone to check that
everything works, a script does it — filling in forms, swiping screens, dragging
items, and signing up a user — and then reports whether each check passed or failed.

The tests don't run on a real physical phone in the office. They run on
**BrowserStack**, a cloud service that provides real and virtual Android devices
over the internet. This means anyone with the right access can run the same tests
without owning the actual device.

There are 5 automated test cases covering different parts of the app: filling out
a form, revealing hidden content by swiping, browsing a carousel, dragging elements
into place, and signing up with a new account.

## What you need before starting

- A computer with **Node.js** installed (version 18 or newer). This is the engine
  that runs the test scripts.
- A **BrowserStack account** (username + access key). This is what gives the tests
  access to a cloud device to run on.
- **Git**, to download the project.
- A terminal (Command Prompt, Git Bash, or similar) to type commands into.

None of this requires programming knowledge — the steps below are copy-paste
commands.

## How to install everything (one-time setup)

1. Download (clone) the project folder to your computer using Git.
2. Open a terminal inside the project folder and run:
   ```bash
   npm install
   ```
   This downloads all the tools the tests need to run. It can take a minute or two.
3. Create a file named `.env` in the project folder (a plain text file, no
   extension tricks needed) with the following content, replacing the placeholders
   with real BrowserStack credentials:
   ```
   BROWSERSTACK_USERNAME=your_username
   BROWSERSTACK_ACCESS_KEY=your_access_key
   BROWSERSTACK_APP_ID=bs://NativeDemoApp
   ```
   These credentials tell BrowserStack who is requesting a device and which app to
   test. They are private — this file should never be shared or uploaded publicly.
4. If the app hasn't been uploaded to BrowserStack yet, upload it once with this
   command (only needs to be done the first time, or whenever the app itself changes):
   ```bash
   curl -u "$BROWSERSTACK_USERNAME:$BROWSERSTACK_ACCESS_KEY" \
     -X POST "https://api-cloud.browserstack.com/app-automate/upload" \
     -F "file=@Android-NativeDemoApp-0.4.0.apk" \
     -F "custom_id=NativeDemoApp"
   ```

## How to run the tests

There are two ready-made configurations, each targeting a different phone model
(this checks that the app behaves consistently across devices). Run either one —
or both, one after another.

Run on device configuration 1 (Samsung Galaxy S22 Ultra):
```bash
npm run wdio
```

Run on device configuration 2 (Google Pixel 8 Pro):
```bash
npm run wdio:device2
```

Run on both, one after another:
```bash
npm run wdio:all
```

To run just one specific test instead of all 5, add `--spec` and the file name, for
example:
```bash
npm run wdio -- --spec e2e/specs/forms.specs.js
```

While the command is running, it connects to a BrowserStack device in the cloud,
opens the app, and performs the test steps automatically. This typically takes a
few minutes depending on how many tests are run.

## How to see the results (report)

After a test run finishes, generate a readable report with:
```bash
npm run report
```

This builds an HTML report from the run's results and opens it automatically in
your browser. The report shows, for each test case, whether it passed or failed,
how long it took, and — for failed tests — screenshots and details of what went
wrong, which is useful for sharing with the development team.