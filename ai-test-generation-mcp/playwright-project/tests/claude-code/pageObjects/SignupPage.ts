import type { Locator } from '@playwright/test';
import { BasePage } from './BasePage';
import type { UserData } from '../testData/userData';

const ACCOUNT_INFORMATION_HEADING = /enter account information/i;
const NEWSLETTER_CHECKBOX = 'Sign up for our newsletter!';
const SPECIAL_OFFERS_CHECKBOX = 'Receive special offers from our partners!';
const TEST_IDS = {
  password: 'password',
  days: 'days',
  months: 'months',
  years: 'years',
  firstName: 'first_name',
  lastName: 'last_name',
  company: 'company',
  address: 'address',
  address2: 'address2',
  country: 'country',
  state: 'state',
  city: 'city',
  zipcode: 'zipcode',
  mobileNumber: 'mobile_number',
  createAccount: 'create-account',
};

export class SignupPage extends BasePage {
  getAccountInformationHeading(): Locator {
    return this.page.getByRole('heading', { name: ACCOUNT_INFORMATION_HEADING });
  }

  async fillAccountInformation(user: UserData): Promise<void> {
    await this.page.getByRole('radio', { name: user.title }).check();
    await this.page.getByTestId(TEST_IDS.password).fill(user.password);
    await this.page.getByTestId(TEST_IDS.days).selectOption(user.birthDay);
    await this.page.getByTestId(TEST_IDS.months).selectOption(user.birthMonth);
    await this.page.getByTestId(TEST_IDS.years).selectOption(user.birthYear);

    if (user.newsletter) {
      await this.page.getByRole('checkbox', { name: NEWSLETTER_CHECKBOX }).check();
    }
    if (user.specialOffers) {
      await this.page.getByRole('checkbox', { name: SPECIAL_OFFERS_CHECKBOX }).check();
    }

    await this.page.getByTestId(TEST_IDS.firstName).fill(user.firstName);
    await this.page.getByTestId(TEST_IDS.lastName).fill(user.lastName);
    await this.page.getByTestId(TEST_IDS.company).fill(user.company);
    await this.page.getByTestId(TEST_IDS.address).fill(user.address);
    await this.page.getByTestId(TEST_IDS.address2).fill(user.address2);
    await this.page.getByTestId(TEST_IDS.country).selectOption(user.country);
    await this.page.getByTestId(TEST_IDS.state).fill(user.state);
    await this.page.getByTestId(TEST_IDS.city).fill(user.city);
    await this.page.getByTestId(TEST_IDS.zipcode).fill(user.zipcode);
    await this.page.getByTestId(TEST_IDS.mobileNumber).fill(user.mobileNumber);
  }

  async createAccount(): Promise<void> {
    await this.page.getByTestId(TEST_IDS.createAccount).click();
  }
}
