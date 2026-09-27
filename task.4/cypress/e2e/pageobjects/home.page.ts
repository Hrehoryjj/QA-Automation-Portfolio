import { BasePage } from './base.page';

export class HomePage extends BasePage {
    navigateToHome(): void {
        this.navigateTo('/');
    }
    protected get navMenuItem() {
       return (itemName: string) =>
            this.headerContainer.find('button, a').contains(itemName);
    }
    clickNavMenuItem(itemName: string): void {
        this.navMenuItem(itemName)
            .trigger('pointerdown', { button: 0 })
            .trigger('pointerup', { button: 0 })
            .click();
    }
    getHeaderContainer() {
        return cy.get('#site-header');
    }
    waitForDropdownToOpen() {
        return cy.get('#main-menu-content');
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
    isNavMenuItemVisible(itemName: string) {
    return this.navMenuItem(itemName);
    }
    getFooterColumnLinks(columnTitle: string) {
        return this.footerContainer
        .contains(columnTitle)
        .parent()
        .find('a[href]')
        .then(($links) =>
            Cypress._.uniq($links.map((_, el) => (el as HTMLAnchorElement).href).get())
        );
    }
    getSocialLink(hostFragment: string) {
    return this.footerContainer.find(`a[href*="${hostFragment}"]`);
    }
    protected get useCaseSectionHeading() {
        return cy.contains('p', 'SELECT USE CASE');
    }
    getUseCaseButtons() {
        // button[aria-pressed] isn't scoped to just this section - other
        // toggle buttons elsewhere on the page can match too, and unlike
        // this section's buttons they may not be visible/on-screen. Only
        // the visible ones belong to the widget under test here (task.7's
        // areAllUseCaseButtonsClickable does the same visible-only filter).
        return cy.get('button[aria-pressed]:visible');
    }
    scrollToUseCaseSection(): void {
        this.useCaseSectionHeading.scrollIntoView();
    }
}