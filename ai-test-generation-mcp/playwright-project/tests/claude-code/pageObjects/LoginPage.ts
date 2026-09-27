import type { Locator } from '@playwright/test';
import { BasePage } from './BasePage';

export class LoginPage extends BasePage {
  getLoginHeading(): Locator {
    return this.page.getByRole('heading', { name: 'Login to your account' });
  }

  getNewUserSignupHeading(): Locator {
    return this.page.getByRole('heading', { name: 'New User Signup!' });
  }

  async signup(name: string, email: string): Promise<void> {
    await this.page.getByTestId('signup-name').fill(name);
    await this.page.getByTestId('signup-email').fill(email);
    await this.page.getByTestId('signup-button').click();
  }

  async login(email: string, password: string): Promise<void> {
    await this.page.getByTestId('login-email').fill(email);
    await this.page.getByTestId('login-password').fill(password);
    await this.page.getByTestId('login-button').click();
  }

  getLoginErrorMessage(): Locator {
    return this.page
      .locator('form', { has: this.page.getByTestId('login-password') })
      .getByText(/your email or password is incorrect/i);
  }

  getSignupErrorMessage(): Locator {
    return this.page
      .locator('form', { has: this.page.getByTestId('signup-email') })
      .getByText(/email address already exist/i);
  }
}
