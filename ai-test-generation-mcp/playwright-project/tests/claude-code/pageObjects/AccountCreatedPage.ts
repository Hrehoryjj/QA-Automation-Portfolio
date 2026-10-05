import type { Locator } from '@playwright/test';
import { BasePage } from './BasePage';

const ACCOUNT_CREATED_HEADING = /account created/i;
const CONTINUE_BUTTON_TEST_ID = 'continue-button';

export class AccountCreatedPage extends BasePage {
  getAccountCreatedHeading(): Locator {
    return this.page.getByRole('heading', { name: ACCOUNT_CREATED_HEADING });
  }

  async clickContinue(): Promise<void> {
    await this.page.getByTestId(CONTINUE_BUTTON_TEST_ID).click();
  }
}
