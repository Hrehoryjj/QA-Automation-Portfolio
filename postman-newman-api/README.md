# Postman + Newman: API Test Automation

[![Postman + Newman (API)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/postman-newman-api.yml/badge.svg)](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/postman-newman-api.yml)

## What it is
Automated tests for the **REST API** of a small online store (products, orders, users). The API runs on a local mock server, and the tests send real requests to it and check every response.

## Why it matters
The API is the layer behind the screens: when it returns wrong data, every app built on it breaks. API tests are fast, need no browser and catch problems before they reach the user interface.

## What is tested
- Correct status codes (200, 201, 404 and others)
- Pagination and sorting of lists
- Response structure, validated against a JSON schema
- A full lifecycle: create a record, update it, delete it, then confirm it can no longer be found

## How it is built
| Part | Tool |
|---|---|
| Test collection | Postman (`store.collection.json`) |
| Command-line runner | Newman |
| API under test | Local mock server (yaml-server) |
| CI/CD | GitHub Actions: starts the server and runs the collection on every push |

## Test results
Every run is visible in **[GitHub Actions](https://github.com/Hrehoryjj/QA-Automation-Portfolio/actions/workflows/postman-newman-api.yml)**: open the latest run and the "Run API tests" step shows each request and check.

## Run it locally
Requires Node.js (LTS) and Git.
```bash
git clone https://github.com/Hrehoryjj/QA-Automation-Portfolio.git
cd QA-Automation-Portfolio/postman-newman-api
npm i
npm run turn-on-api    # starts the API on http://localhost:3000, keep it running
```
In a second terminal, from the same folder:
```bash
npm test               # runs the collection and prints the results
```
You can also import `store.collection.json` into Postman and run it with the Collection Runner.
