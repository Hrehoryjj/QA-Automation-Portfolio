// ***********************************************************
// This example support/e2e.js is processed and
// loaded automatically before your test files.
//
// This is a great place to put global configuration and
// behavior that modifies Cypress.
//
// You can change the location of this file or turn off
// automatically serving support files with the
// 'supportFile' configuration option.
//
// You can read more here:
// https://on.cypress.io/configuration
// ***********************************************************

// Import commands.js using ES2015 syntax:
import 'cypress-mochawesome-reporter/register';
import './commands'

// telnyx.com serves an Origin-Trial token enabling Chrome's WebMCP API
// (navigator.modelContext / document.modelContext). That API throws when
// called on a document where Cypress's spec-bridge has assigned
// document.domain, crashing tests with an opaque cross-origin "Script
// error.". Remove the API before any page script runs, so feature-detection
// (`if (navigator.modelContext)`) sees it as absent - same as it is for the
// vast majority of real visitors' browsers - and never calls into it.
Cypress.on('window:before:load', (win) => {
  delete win.Navigator.prototype.modelContext;
  delete win.Document.prototype.modelContext;
});

// Safety net in case some other page script still throws the same class of
// cross-origin noise; a real bug in our own page code still fails the test
// with an actual message/stack trace.
Cypress.on('uncaught:exception', (err) => {
  if (
    err.message.includes('document.modelContext cannot be used when document.domain is enabled') ||
    err.message === 'Script error.'
  ) {
    return false;
  }
});