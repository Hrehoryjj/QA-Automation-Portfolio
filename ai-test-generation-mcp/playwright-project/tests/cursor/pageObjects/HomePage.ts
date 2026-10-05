import type { Locator } from '@playwright/test';
import { BasePage } from './BasePage';

const HOME_PATH = '/';
const FOOTER = '#footer';
const SUBSCRIPTION_HEADING = '#footer h2';
const SUBSCRIPTION_EMAIL_INPUT = '#susbscribe_email';
const SUBSCRIBE_BUTTON = '#subscribe';
const SUBSCRIPTION_SUCCESS_MESSAGE = '#success-subscribe .alert-success';

export class HomePage extends BasePage {
  async goto(): Promise<void> {
    await this.open(HOME_PATH);
  }

  async scrollToFooter(): Promise<void> {
    await this.page.locator(FOOTER).scrollIntoViewIfNeeded();
  }

  getSubscriptionHeading(): Locator {
    return this.page.locator(SUBSCRIPTION_HEADING);
  }

  async enterSubscriptionEmail(email: string): Promise<void> {
    await this.page.locator(SUBSCRIPTION_EMAIL_INPUT).fill(email);
  }

  async clickSubscribeButton(): Promise<void> {
    await this.page.locator(SUBSCRIBE_BUTTON).click();
  }

  getSubscriptionSuccessMessage(): Locator {
    return this.page.locator(SUBSCRIPTION_SUCCESS_MESSAGE);
  }
}
