import { defineConfig } from 'cypress';
import mochawesome from 'cypress-mochawesome-reporter/plugin';

export default defineConfig({
  projectId: 'wrecjm',
  reporter: 'cypress-mochawesome-reporter',
  reporterOptions: {
    charts: true,
    reportPageTitle: 'Task 12 — Cypress',
    embeddedScreenshots: true,
    inlineAssets: true,
  },
  video: false,
  screenshotOnRunFailure: true,
  defaultCommandTimeout: 10_000,
  allowCypressEnv: false,
  e2e: {
    baseUrl: 'https://automationexercise.com',
    specPattern: 'cypress/e2e/**/*.cy.ts',
    supportFile: 'cypress/support/e2e.ts',
    setupNodeEvents(on) {
      mochawesome(on);
    },
  },
});
