import { HomePage } from '../pages/home.page';

const homePage = new HomePage();

describe('Navigation', () => {
    let navData: { menuItem: string; submenuLink: string }[];

    before(() => {
        cy.fixture('testData').then((data) => {
            navData = data.navigation.menus;
        });
    });

    beforeEach(() => {
        homePage.navigateToHome();
    });

    it('TC-01: Home Page Loads Successfully', () => {
        cy.url().should('eq', 'https://telnyx.com/');
        cy.title().should('not.be.empty');
    });

    it('TC-02: Logo Click Redirects to Home Page', () => {
        homePage.navigateTo('/pricing');
        homePage.clickLogo();
        cy.url().should('eq', 'https://telnyx.com/');
    });

    it('TC-03: Navigation Menu Dropdown Appears on Click', () => {
        const { menuItem } = navData[0]!;
        homePage.clickNavMenuItem(menuItem);
        homePage.waitForDropdownToOpen().should('be.visible');
    });

    it('TC-04: Navigation Submenu Link Redirects to Correct Page', () => {
        const { menuItem, submenuLink } = navData[0]!;
        homePage.clickNavMenuItem(menuItem);
        homePage.clickSubmenuLink(submenuLink);
        cy.url().should('include', '/products/voice-api');
    });
});