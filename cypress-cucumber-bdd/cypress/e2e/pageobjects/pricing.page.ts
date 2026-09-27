import { BasePage } from './base.page';

export class PricingPage extends BasePage {
    // The pricing page redesign moved these behind data-state tab panels
    // (same pattern confirmed in task.7's already-updated pricing.page.ts);
    // "Messaging API" is also no longer link text - match by href instead.
    private static readonly MESSAGING_API_LINK = 'a[href="/pricing/messaging"]';
    private static readonly SERVICES_TABLE = 'div[data-state="active"] table';
    private static readonly PRICE_CELLS = 'div[data-state="active"] table tbody td div.bg-transparent';

    navigateToPricing(): void {
        this.navigateTo('/pricing');
    }
    getMessagingApiLink() {
        // The same href appears more than once on the page (e.g. desktop
        // nav + mobile nav) - scrollIntoView/click need exactly one target.
        return cy.get(PricingPage.MESSAGING_API_LINK).first();
    }
    clickMessagingApiLink(): void {
        this.getMessagingApiLink().scrollIntoView().click({ force: true });
    }
    getPriceCellsWithDollar() {
        return cy.get(PricingPage.PRICE_CELLS).filter(':contains("$")');
    }
    getServicesTable() {
        return cy.get(PricingPage.SERVICES_TABLE);
    }
}