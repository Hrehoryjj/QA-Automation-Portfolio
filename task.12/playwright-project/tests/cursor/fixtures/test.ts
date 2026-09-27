import { test as base, expect } from '@playwright/test';

const BLOCKED_AD_HOSTS = [
  'googlesyndication.com',
  'doubleclick.net',
  'googletagservices.com',
  'adtrafficquality.google',
  'fundingchoicesmessages.google.com',
];

export const test = base.extend({
  page: async ({ page }, use) => {
    await page.route(
      (url) => BLOCKED_AD_HOSTS.some((host) => url.hostname.includes(host)),
      (route) => route.abort(),
    );
    await use(page);
  },
});

export { expect };
