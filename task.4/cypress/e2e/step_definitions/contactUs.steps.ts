import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';
import { faker } from '@faker-js/faker';
import { ContactUsPage } from '../pageobjects/contactUs.page';

const contactUsPage = new ContactUsPage();
let generatedSymbol: string;

Given('I am on the contact-us page', () => {
  contactUsPage.visitContactUs();
});
Then('the submit button should be clickable', () => {
  contactUsPage.getSubmitButton().should('be.visible').and('not.be.disabled');
});
When('I click on the contact reason dropdown', () => {
  contactUsPage.getReasonForContactDropdown().focus();
});
Then('two options should appear', () => {
  // The first <option> is a non-selectable placeholder ("Select") shown in
  // the dropdown; only the remaining options are real, selectable reasons.
  contactUsPage.getReasonForContactDropdown().find('option:not([value=""])').should('have.length', 2);
});
When('I input a randomly generated symbol into the contact form fields', () => {
  generatedSymbol = faker.string.alpha(1).toUpperCase();
  contactUsPage.getFormFields().each(($field) => {
    cy.wrap($field).type(generatedSymbol);
  });
});
Then('the fields should accept the symbol', () => {
  contactUsPage.getFormFields().each(($field) => {
    cy.wrap($field).should('have.value', generatedSymbol);
  });
});
When('I clear the fields', () => {
  contactUsPage.getFormFields().each(($field) => {
    cy.wrap($field).clear();
  });
});
Then('the fields should be empty', () => {
  contactUsPage.getFormFields().each(($field) => {
    cy.wrap($field).should('have.value', '');
  });
});
// The OneTrust consent widget only shows for regions/sessions it flags as
// needing consent, which the CI runner's IP doesn't control (task.7's
// TC-20 documents the same behavior). When it's absent for this run, the
// remaining steps in this scenario have nothing to verify and skip cleanly
// instead of failing on a widget that was never going to appear.
let cookieWidgetPresent = true;

When('I see coockie settings button', () => {
  contactUsPage.isCookieWidgetPresent().then((present) => {
    cookieWidgetPresent = present;
  });
});
When('I click the cookie settings button', () => {
  if (!cookieWidgetPresent) return;
  contactUsPage.clickCookieSettings();
});
Then('the cookie settings panel should appear', () => {
  if (!cookieWidgetPresent) {
    cy.log('Cookie consent widget was not shown for this session/region - skipping verification.');
    return;
  }
  contactUsPage.getCookeSettingsPanel().should('be.visible');
});
When('I confirm my cookie choices', () => {
  if (!cookieWidgetPresent) return;
  contactUsPage.acceptConfirmChoicesButton().click({ force: true });
});
Then('the choice should be confirmed', () => {
  if (!cookieWidgetPresent) {
    cy.log('Cookie consent widget was not shown for this session/region - skipping verification.');
    return;
  }
  contactUsPage.getCookeSettingsPanel().should('not.be.visible');
});
Then('the cookie settings button should be visible', () => {
  contactUsPage.detectCoockiesettings().should('be.visible');
});