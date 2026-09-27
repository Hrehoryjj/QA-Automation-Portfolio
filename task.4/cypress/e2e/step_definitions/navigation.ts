import { When, Then } from '@badeball/cypress-cucumber-preprocessor';
import { HomePage } from '../pageobjects/home.page';
import testData from '../../fixtures/testData.json';
const homePage = new HomePage();
Then('the main header area with the Telnyx logo should be visible', () => {
  homePage.getHeaderContainer().should('be.visible');
});
When('I click the logo', () => {
  homePage.clickLogo();
});
Then('I should be redirected to the main page', () => {
  cy.location('pathname').should('eq', '/');
});
Then('all 6 navigation tabs should be visible in the header', () => {
  testData.mainNavItems.forEach((item) => {
    homePage.isNavMenuItemVisible(item).should('be.visible');
  });
});
When('I click on the {string} navigation dropdown', (itemName: string) => {
  homePage.clickNavMenuItem(itemName);
});
Then('the dropdown should appear', () => {
  homePage.waitForDropdownToOpen().should('be.visible');
});
// The homepage's AI-model tabs (role="tab", fixed names like Inference/
// Voice Agent Builder/...) were redesigned into a "SELECT USE CASE" button
// group (button[aria-pressed]) - same widget as task.7/task.3.cypress
// already confirmed against the live site. The old tab names no longer
// exist, so these steps check the current widget's real contract instead.
When('I scroll to the AI agents tabs', () => {
  homePage.scrollToUseCaseSection();
});
Then('the tabs should be visible', () => {
  homePage.getUseCaseButtons().should('have.length.greaterThan', 0);
  homePage.getUseCaseButtons().each(($button) => {
    cy.wrap($button).should('be.visible');
  });
});
Then('the tabs should be clickable', () => {
  homePage.getUseCaseButtons().each(($button) => {
    cy.wrap($button)
      .click()
      .should('have.attr', 'aria-pressed', 'true');
  });
});