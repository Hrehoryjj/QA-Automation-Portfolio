import { expect } from '@wdio/globals';
import homePage from '../pageobjects/home.page';

describe('Header Navigation', () => {
  beforeEach(async () => {
    await homePage.navigateToHome();
  });

  it('TC-04: logo click should redirect to home page', async () => {
    await browser.url('/pricing');
    await homePage.clickLogo();
    await expect(browser).toHaveUrl('https://telnyx.com/');
  });

  it('TC-05: main navigation should display all top-level menu items', async () => {
    expect(await homePage.areAllTopLevelNavItemsDisplayed()).toBe(true);
  });

  it('TC-06: navigation dropdown should appear on click', async () => {
    await homePage.openSolutionsDropdown();
    expect(await homePage.isDropdownDisplayed()).toBe(true);
  });

  it('TC-07: submenu link should redirect to correct page', async () => {
    await homePage.openProductsDropdown();
    await homePage.clickViewAllPrimitivesLink();
    await expect(browser).toHaveUrl(expect.stringContaining('/products'));
  });

  it('TC-08: "Why Telnyx" dropdown should appear on click', async () => {
    await homePage.openWhyTelnyxDropdown();
    expect(await homePage.isDropdownDisplayed()).toBe(true);
  });

  it('TC-09: Developers dropdown should contain documentation link', async () => {
    await homePage.openDevelopersDropdown();
    expect(await homePage.isDevDocsLinkDisplayed()).toBe(true);
    expect(await homePage.isDevDocsLinkClickable()).toBe(true);
  });
});