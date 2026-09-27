import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';
import { HomePage } from '../pageobjects/home.page';

const homePage = new HomePage();

Given('the base URL is accessible', () => {
  cy.request('/').its('status').should('eq', 200);
});
When('I navigate to the base URL', () => {
  homePage.navigateToHome();
});
Then('the user should be on the main page and it should be loaded', () => {
  cy.location('pathname').should('eq', '/');
  cy.get('body').should('be.visible');
});
Given('I am on the home page', () => {
  homePage.navigateToHome();
});
Given('I am navigated to any internal subpage', () => {
  homePage.navigateTo('/pricing');
});
When('I click on {string}', (text: string) => {
  cy.contains(text)
  .click({ force: true });
});
Then('I should be redirected to the {string} page', (path: string) => {
  cy.location('pathname').should('eq', path);
});