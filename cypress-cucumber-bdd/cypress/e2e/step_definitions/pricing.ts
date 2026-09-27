import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';
import { PricingPage } from '../pageobjects/pricing.page';

const pricingPage = new PricingPage();
Given('I navigate to the pricing page', () => {
  pricingPage.navigateToPricing();
});
When('I click the Messaging API pricing link', () => {
  pricingPage.clickMessagingApiLink();
});
Then('the services table should be visible', () => {
  pricingPage.getServicesTable().should('be.visible');
});
Then('all displayed prices should be greater than 0', () => {
  pricingPage.getPriceCellsWithDollar().should('have.length.greaterThan', 0);
  pricingPage.getPriceCellsWithDollar().each(($cell) => {
    const value = parseFloat($cell.text().replace(/[^0-9.]/g, ''));
    expect(value).to.be.greaterThan(0);
  });
});