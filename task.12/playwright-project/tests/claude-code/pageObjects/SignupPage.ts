import type { Locator } from '@playwright/test';
import { BasePage } from './BasePage';
import type { UserData } from '../testData/userData';

export class SignupPage extends BasePage {
  getAccountInformationHeading(): Locator {
    return this.page.getByRole('heading', { name: /enter account information/i });
  }

  async fillAccountInformation(user: UserData): Promise<void> {
    await this.page.getByRole('radio', { name: user.title }).check();
    await this.page.getByTestId('password').fill(user.password);
    await this.page.getByTestId('days').selectOption(user.birthDay);
    await this.page.getByTestId('months').selectOption(user.birthMonth);
    await this.page.getByTestId('years').selectOption(user.birthYear);

    if (user.newsletter) {
      await this.page.getByRole('checkbox', { name: 'Sign up for our newsletter!' }).check();
    }
    if (user.specialOffers) {
      await this.page.getByRole('checkbox', { name: 'Receive special offers from our partners!' }).check();
    }

    await this.page.getByTestId('first_name').fill(user.firstName);
    await this.page.getByTestId('last_name').fill(user.lastName);
    await this.page.getByTestId('company').fill(user.company);
    await this.page.getByTestId('address').fill(user.address);
    await this.page.getByTestId('address2').fill(user.address2);
    await this.page.getByTestId('country').selectOption(user.country);
    await this.page.getByTestId('state').fill(user.state);
    await this.page.getByTestId('city').fill(user.city);
    await this.page.getByTestId('zipcode').fill(user.zipcode);
    await this.page.getByTestId('mobile_number').fill(user.mobileNumber);
  }

  async createAccount(): Promise<void> {
    await this.page.getByTestId('create-account').click();
  }
}
