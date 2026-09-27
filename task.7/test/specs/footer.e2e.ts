import { expect } from '@wdio/globals';
import homePage from '../pageobjects/home.page';

describe('Footer', () => {
  beforeEach(async () => {
    await homePage.navigateToHome();
  });

  it('TC-11: COMPANY section links should return HTTP 200', async () => {
    const links = await homePage.getFooterColumnLinks('COMPANY');
    expect(links.length).toBeGreaterThan(0);
    for (const url of links) {
      const response = await fetch(url);
      expect(response.status).toBe(200);
    }
  });

  it('TC-12: LEGAL section links should return HTTP 200 or 403', async () => {
    const links = await homePage.getFooterColumnLinks('LEGAL');
    expect(links.length).toBeGreaterThan(0);
    for (const url of links) {
      const response = await fetch(url);
      expect([200, 403]).toContain(response.status);
  }
  });

  it('TC-13: COMPARE section links should return HTTP 200', async () => {
    const links = await homePage.getFooterColumnLinks('COMPARE');
    expect(links.length).toBeGreaterThan(0);
    for (const url of links) {
      const response = await fetch(url);
      expect(response.status).toBe(200);
    }
  });

  it('TC-14: social icons should link to correct external profiles', async () => {
    expect(await homePage.getSocialLinkTarget('linkedin.com')).toBe('_blank');
    expect(await homePage.getSocialLinkTarget('x.com')).toBe('_blank');
    expect(await homePage.getSocialLinkTarget('facebook.com')).toBe('_blank');
  });

  it('TC-15: Shop link should open external site in new tab', async () => {
    expect(await homePage.getShopLinkHref()).toBe('https://shop.telnyx.com/');
    expect(await homePage.getShopLinkTarget()).toBe('_blank');
  });

  it('TC-16: footer copyright text should show current year', async () => {
    const currentYear = new Date().getFullYear().toString();
    const copyrightText = await homePage.getFooterCopyrightText();
    expect(copyrightText).toContain(currentYear);
  });
});