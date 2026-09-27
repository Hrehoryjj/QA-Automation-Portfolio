import type { Page, Locator } from '@playwright/test';

export class BasePage {
  constructor(protected readonly page: Page) {}

  async open(path: string): Promise<void> {
    await this.page.goto(path);
  }

  async clickDeleteAccount(): Promise<void> {
    await this.page.getByRole('link', { name: 'Delete Account' }).click();
  }

  async clickCartLink(): Promise<void> {
    await this.page.getByRole('banner').getByRole('link', { name: 'Cart' }).click();
  }

  getLoggedInAsLabel(): Locator {
    return this.page.getByText(/Logged in as/i);
  }
}
