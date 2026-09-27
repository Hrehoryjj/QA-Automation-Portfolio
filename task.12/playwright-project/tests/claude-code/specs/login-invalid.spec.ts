import { test, expect } from '../fixtures/test';
import { LoginPage } from '../pageObjects/LoginPage';

test.describe('TC-07 Login with incorrect email or password', () => {
  test('shows an error and does not log the user in', async ({ page }) => {
    const loginPage = new LoginPage(page);

    await loginPage.open('/login');
    await expect(loginPage.getLoginHeading()).toBeVisible();

    await loginPage.login('no-such-user@example-mail.test', 'WrongPass1!');

    await expect(loginPage.getLoginErrorMessage()).toBeVisible();
    await expect(loginPage.getLoggedInAsLabel()).toHaveCount(0);
  });
});
