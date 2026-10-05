import type { Locator } from '@playwright/test';
import { BasePage } from './BasePage';

const LOGIN_HEADING = 'Login to your account';
const NEW_USER_SIGNUP_HEADING = 'New User Signup!';
const SIGNUP_NAME_TEST_ID = 'signup-name';
const SIGNUP_EMAIL_TEST_ID = 'signup-email';
const SIGNUP_BUTTON_TEST_ID = 'signup-button';
const LOGIN_EMAIL_TEST_ID = 'login-email';
const LOGIN_PASSWORD_TEST_ID = 'login-password';
const LOGIN_BUTTON_TEST_ID = 'login-button';
const FORM = 'form';
const LOGIN_ERROR_TEXT = /your email or password is incorrect/i;
const SIGNUP_ERROR_TEXT = /email address already exist/i;

export class LoginPage extends BasePage {
  getLoginHeading(): Locator {
    return this.page.getByRole('heading', { name: LOGIN_HEADING });
  }

  getNewUserSignupHeading(): Locator {
    return this.page.getByRole('heading', { name: NEW_USER_SIGNUP_HEADING });
  }

  async signup(name: string, email: string): Promise<void> {
    await this.page.getByTestId(SIGNUP_NAME_TEST_ID).fill(name);
    await this.page.getByTestId(SIGNUP_EMAIL_TEST_ID).fill(email);
    await this.page.getByTestId(SIGNUP_BUTTON_TEST_ID).click();
  }

  async login(email: string, password: string): Promise<void> {
    await this.page.getByTestId(LOGIN_EMAIL_TEST_ID).fill(email);
    await this.page.getByTestId(LOGIN_PASSWORD_TEST_ID).fill(password);
    await this.page.getByTestId(LOGIN_BUTTON_TEST_ID).click();
  }

  getLoginErrorMessage(): Locator {
    return this.page
      .locator(FORM, { has: this.page.getByTestId(LOGIN_PASSWORD_TEST_ID) })
      .getByText(LOGIN_ERROR_TEXT);
  }

  getSignupErrorMessage(): Locator {
    return this.page
      .locator(FORM, { has: this.page.getByTestId(SIGNUP_EMAIL_TEST_ID) })
      .getByText(SIGNUP_ERROR_TEXT);
  }
}
