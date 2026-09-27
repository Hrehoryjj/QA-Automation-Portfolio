import type { Locator } from '@playwright/test';
import { BasePage } from './BasePage';

export class AccountDeletedPage extends BasePage {
  getAccountDeletedHeading(): Locator {
    return this.page.getByRole('heading', { name: /account deleted/i });
  }
}
