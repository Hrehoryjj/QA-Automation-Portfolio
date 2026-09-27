import type { Locator } from '@playwright/test';
import { BasePage } from './BasePage';

export class HomePage extends BasePage {
  async goto(): Promise<void> {
    await this.open('/');
  }

  async scrollToFooter(): Promise<void> {
    await this.page.locator('#footer').scrollIntoViewIfNeeded();
  }

  getSubscriptionHeading(): Locator {
    return this.page.locator('#footer h2');
  }

  async enterSubscriptionEmail(email: string): Promise<void> {
    await this.page.locator('#susbscribe_email').fill(email);
  }

  async clickSubscribeButton(): Promise<void> {
    await this.page.locator('#subscribe').click();
  }

  getSubscriptionSuccessMessage(): Locator {
    return this.page.locator('#success-subscribe .alert-success');
  }
}
