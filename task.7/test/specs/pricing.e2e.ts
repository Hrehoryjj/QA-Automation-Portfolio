import { expect } from '@wdio/globals';
import pricingPage from '../pageobjects/pricing.page';

describe('Pricing Page', () => {
  it('TC-10: messaging API pricing table should display valid price values', async () => {
    await pricingPage.navigateToPricing();
    await pricingPage.clickMessagingApiLink();
    await expect(browser).toHaveUrl(expect.stringContaining('/pricing/messaging'));
    expect(await pricingPage.isServicesTableDisplayed()).toBe(true);

    const prices = await pricingPage.getPriceCellsValues();
    expect(prices.length).toBeGreaterThan(0);
    prices.forEach((price) => expect(price).toBeGreaterThan(0));
  });
});