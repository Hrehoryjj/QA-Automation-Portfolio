import { BasePage } from './base.page';

export class HomePage extends BasePage {
    navigateToHome(): void {
        this.navigateTo('/');
    }
    protected get navMenuItem() {
        return (itemName: string) =>
            this.headerContainer.find('button[aria-haspopup="menu"]').contains(itemName);
    }
    clickNavMenuItem(itemName: string): void {
        this.navMenuItem(itemName)
            .trigger('pointerdown', { button: 0 })
            .trigger('pointerup', { button: 0 })
            .click({ force: true });
    }
    waitForDropdownToOpen() {
        return cy.get('[role="menu"]');
    }
    protected get submenuLink() {
        return (linkText: string) => cy.get('[role="menu"]').contains('a', linkText);
    }
    clickSubmenuLink(linkText: string): void {
        this.submenuLink(linkText).click();
    }
    protected get useCaseSectionHeading() {
        return cy.contains('p', 'SELECT USE CASE');
    }
    getUseCaseButtons(): Cypress.Chainable<JQuery<HTMLElement>> {
        // button[aria-pressed] isn't scoped to just this section - other
        // toggle buttons elsewhere on the page can match too, and unlike
        // this section's buttons they may not be visible/on-screen. Only
        // the visible ones belong to the widget under test here.
        return cy.get('button[aria-pressed]:visible');
    }
    scrollToUseCaseSection(): void {
        this.useCaseSectionHeading.scrollIntoView();
    }
    protected get contactUsButton() {
        return cy.contains('a, button', 'Contact us');
    }
    clickContactUsButton(): void {
        this.contactUsButton.click();
    }
    isContactUsButtonClickable() {
        return this.contactUsButton;
    }
    protected acceptCookiesIfPresent(): void {
        cy.get('body').then(($body) => {
            const acceptButton = $body.find('button:contains("Accept All")');
            if (acceptButton.length > 0) {
                cy.wrap(acceptButton.first()).click();
            }
        });
    }
    protected get headerContainer() {
        return cy.get('#site-header');
    }
    protected get footerContainer() {
        return cy.get('#site-footer');
    }
    protected get telnyxLogo() {
        return this.headerContainer.find('a[href="/"]').first();
    }
    clickLogo(): void {
        this.telnyxLogo.click();
    }
}