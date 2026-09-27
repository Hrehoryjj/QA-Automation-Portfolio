export class BasePage {
    navigateTo(url: string): void {
        cy.visit(url);
    }
}