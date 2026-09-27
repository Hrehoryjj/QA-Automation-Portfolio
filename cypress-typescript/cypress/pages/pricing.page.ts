import { BasePage } from './base.page';

export class PricingPage extends BasePage {
    // The pricing page redesign moved the price table behind data-state tab
    // panels; only the active panel holds the prices a visitor sees.
    private static readonly PRICE_CELLS = 'div[data-state="active"] table tbody td div.bg-transparent';

    navigateToPricing(): void {
        this.navigateTo('/pricing/messaging');
    }
    getPriceCellsWithDollar() {
        return cy.get(PricingPage.PRICE_CELLS).filter(':contains("$")');
    }
}
