import type { Locator } from '@playwright/test';
import { BasePage } from './BasePage';

export class AccountCreatedPage extends BasePage {
  getAccountCreatedHeading(): Locator {
    return this.page.getByRole('heading', { name: /account created/i });
  }

  async clickContinue(): Promise<void> {
    await this.page.getByTestId('continue-button').click();
  }
}
