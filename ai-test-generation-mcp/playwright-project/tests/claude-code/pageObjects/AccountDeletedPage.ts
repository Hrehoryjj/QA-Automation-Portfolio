import type { Locator } from '@playwright/test';
import { BasePage } from './BasePage';

const ACCOUNT_DELETED_HEADING = /account deleted/i;

export class AccountDeletedPage extends BasePage {
  getAccountDeletedHeading(): Locator {
    return this.page.getByRole('heading', { name: ACCOUNT_DELETED_HEADING });
  }
}
