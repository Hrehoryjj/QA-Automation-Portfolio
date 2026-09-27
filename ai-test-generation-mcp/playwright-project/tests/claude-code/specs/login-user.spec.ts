import { test, expect } from '../fixtures/test';
import { LoginPage } from '../pageObjects/LoginPage';

test.describe('TC-02 Login User with correct email and password', () => {
  test('a registered user can log in with valid credentials', async ({ page, registeredUser }) => {
    const loginPage = new LoginPage(page);

    await loginPage.open('/login');
    await expect(loginPage.getLoginHeading()).toBeVisible();

    await loginPage.login(registeredUser.email, registeredUser.password);

    await expect(loginPage.getLoggedInAsLabel()).toContainText(registeredUser.name);
  });
});
