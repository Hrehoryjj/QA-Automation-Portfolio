# Task.5 — Postman + Newman + GitHub Actions

This project is part of a QA automation trainee program. The goal is to test the REST API of a mock server (the "Simple store" template) using Postman tests, automate the run with Newman, and hook it up to GitHub Actions so tests run automatically on every push.

## What's here

```
task.5/
├── mockApi/                   # data for the local mock server
├── package.json                # dependencies and npm scripts
├── store.collection.json       # Postman collection with tests (products/orders/users)
├── petstore.collection.json    # test collection for the public petstore API
└── README.md                   # this file
```

## What's being tested

The mock server emulates a simple online store REST API with three resources: `products`, `orders`, `users`. Each supports standard operations: list, get by id, create, update, delete.

The `store.collection.json` collection includes tests for:
- correct response status codes (200, 201, 404, etc.)
- pagination (`?page=&pageSize=`)
- sorting (`?sortKey=&sortOrder=`)
- response structure validation (JSON schema)
- a "create → update → delete → re-fetch" scenario (verifying a deleted record can no longer be found)

## How to run the tests locally

You'll need [Node.js](https://nodejs.org/) (any LTS version) and [Postman](https://www.postman.com/downloads/) (optional, for browsing the collection manually).

1. Install dependencies:
   ```bash
   npm i
   ```

2. Start the local mock server:
   ```bash
   npm run turn-on-api
   ```
   The server starts on `http://localhost:3000`. The terminal will print a list of available routes — that's confirmation it's running.

3. Run the tests with Newman (in a separate terminal, while the server is running):
   ```bash
   npm test
   ```
   The console will print a report of how many requests ran and how many tests passed/failed.

   Alternative — open `store.collection.json` in Postman (Import → select the file) and run tests manually via **Send** on each request, or through the built-in **Collection Runner**.

## Automated run (CI)

On every push to the repository, GitHub Actions automatically:
1. Installs dependencies
2. Starts the local server
3. Installs Newman
4. Runs `store.collection.json`

Results can be checked in the **Actions** tab of the GitHub repository — a green checkmark means all tests passed, a red X means something failed (check the step logs for details).

Config file: `.github/workflows/newman.yml` (in the repo root).