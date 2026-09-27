import { PricingPage } from '../pages/pricing.page';

const pricingPage = new PricingPage();

describe('Pricing', () => {
    beforeEach(() => {
        pricingPage.navigateToPricing();
    });

    it('TC-05: Pricing Page Displays Valid Price Values', () => {
        pricingPage.getPriceCellsWithDollar().should('have.length.greaterThan', 0);

        pricingPage.getPriceCellsWithDollar().each(($cell) => {
            const text = $cell.text().trim();
            const match = text.match(/\$(\d+(\.\d+)?)/);

            expect(match, `price cell text: "${text}"`).to.not.be.null;

            const priceNumber = parseFloat(match![1]);
            expect(priceNumber).to.be.a('number');
            expect(priceNumber).to.be.greaterThan(0);
        });
    });
});