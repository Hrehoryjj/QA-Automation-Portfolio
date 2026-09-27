import { test as base, expect } from '@playwright/test';
import { generateUser, type UserData } from '../testData/userData';
import { createUser, deleteUser } from '../api/userApi';

const BLOCKED_AD_HOSTS = [
  'googlesyndication.com',
  'doubleclick.net',
  'googletagservices.com',
  'adtrafficquality.google',
  'fundingchoicesmessages.google.com',
];

type Fixtures = {
  registeredUser: UserData;
};

export const test = base.extend<Fixtures>({
  page: async ({ page }, use) => {
    await page.route(
      (url) => BLOCKED_AD_HOSTS.some((host) => url.hostname.includes(host)),
      (route) => route.abort(),
    );
    await use(page);
  },

  registeredUser: async ({ request }, use) => {
    const user = generateUser();
    await createUser(request, user);
    await use(user);
    await deleteUser(request, user.email, user.password);
  },
});

export { expect };
