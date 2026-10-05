import type { Page, Locator } from '@playwright/test';

const DELETE_ACCOUNT_LINK = 'Delete Account';
const CART_LINK = 'Cart';
const LOGGED_IN_AS_LABEL = /Logged in as/i;

export class BasePage {
  constructor(protected readonly page: Page) {}

  async open(path: string): Promise<void> {
    await this.page.goto(path);
  }

  async clickDeleteAccount(): Promise<void> {
    await this.page.getByRole('link', { name: DELETE_ACCOUNT_LINK }).click();
  }

  async clickCartLink(): Promise<void> {
    await this.page.getByRole('banner').getByRole('link', { name: CART_LINK }).click();
  }

  getLoggedInAsLabel(): Locator {
    return this.page.getByText(LOGGED_IN_AS_LABEL);
  }
}
