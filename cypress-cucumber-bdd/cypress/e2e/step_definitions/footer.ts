import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';
import { HomePage } from '../pageobjects/home.page';
import testData from '../../fixtures/testData.json';

const homePage = new HomePage();
let extractedUrls: string[] = [];

Given('Cypress environment is properly configured', () => {
  expect(Cypress.config('baseUrl')).to.be.a('string');
});
When('I extract an array of URLs from all links inside the {string} column in the footer', (columnTitle: string) => {
  homePage.getFooterColumnLinks(columnTitle).then((links: string[]) => {
    extractedUrls = links;
    expect(extractedUrls.length).to.be.greaterThan(0);
  });
});
Then('the server response for every URL should return HTTP status code 200 or 403 if links protected by bot-detection', () => {
  extractedUrls.forEach((url) => {
    cy.request({ url, failOnStatusCode: false }).its('status').should('match', /^(200|403)$/);
  });
});
Then('the {string} icon should be clickable', (network: string) => {
  homePage.getSocialLink(testData.socialLinks[network as keyof typeof testData.socialLinks]).should('be.visible');
});
Then('it should link to {string}', (host: string) => {
  homePage.getSocialLink(host).should('have.attr', 'href').and('include', host);
  homePage.getSocialLink(host).should('have.attr', 'target', '_blank');
});