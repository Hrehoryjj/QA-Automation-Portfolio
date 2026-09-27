import { HomePage } from '../pages/home.page';
import { faker } from '@faker-js/faker';
const homePage = new HomePage();
describe('UI', () => {
    beforeEach(() => {
        homePage.navigateToHome();
    });
    it('TC-06: Use case buttons are visible and clickable', () => {
        // The homepage's AI-model tabs (role="tab") were redesigned into a
        // "SELECT USE CASE" button group (button[aria-pressed]); the site no
        // longer exposes the old tab names, so this checks the current
        // widget's real contract instead: each button is visible, clickable,
        // and toggles its own aria-pressed state on click.
        homePage.scrollToUseCaseSection();
        homePage.getUseCaseButtons()
            .should('have.length.greaterThan', 0)
            .each(($button) => {
                cy.wrap($button)
                    .scrollIntoView()
                    .should('be.visible')
                    .click()
                    .should('have.attr', 'aria-pressed', 'true');
            });
    });
    it('TC-07: Contact Us Submit Button Is Clickable', () => {
        homePage
            .isContactUsButtonClickable()
            .should('be.visible')
            .and('not.be.disabled');
    });
});