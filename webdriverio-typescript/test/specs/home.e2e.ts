import { expect } from '@wdio/globals';
import homePage from '../pageobjects/home.page';

describe('Home Page', () => {
  beforeEach(async () => {
    await homePage.navigateToHome();
  });

  it('TC-01: should load home page successfully', async () => {
    await expect(browser).toHaveUrl(expect.stringContaining('telnyx.com'));
    expect(await homePage.isHeaderDisplayed()).toBe(true);
  });

 it('TC-02: should display use case buttons and be clickable', async () => {
  const count = await homePage.getUseCaseButtonsCount();
  expect(count).toBeGreaterThan(0);
  expect(await homePage.areAllUseCaseButtonsClickable()).toBe(true);
});

  it('TC-03: should display security certification badges', async () => {
    const badgesText = await homePage.getSecurityBadgesText();
    expect(badgesText).toContain('ISO');
    expect(badgesText).toContain('GDPR');
  });
});