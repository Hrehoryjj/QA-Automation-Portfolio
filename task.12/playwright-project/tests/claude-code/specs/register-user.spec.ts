import { test, expect } from '../fixtures/test';
import { LoginPage } from '../pageObjects/LoginPage';
import { SignupPage } from '../pageObjects/SignupPage';
import { AccountCreatedPage } from '../pageObjects/AccountCreatedPage';
import { AccountDeletedPage } from '../pageObjects/AccountDeletedPage';
import { generateUser, type UserData } from '../testData/userData';
import { deleteUserIfExists } from '../api/userApi';

test.describe('TC-01 Register User', () => {
  let user: UserData;

  test.afterEach(async ({ request }) => {
    await deleteUserIfExists(request, user.email, user.password);
  });

  test('a new user can register with valid data and delete the account', async ({ page }) => {
    user = generateUser();

    const loginPage = new LoginPage(page);
    const signupPage = new SignupPage(page);
    const accountCreatedPage = new AccountCreatedPage(page);
    const accountDeletedPage = new AccountDeletedPage(page);

    await loginPage.open('/login');
    await expect(loginPage.getNewUserSignupHeading()).toBeVisible();

    await loginPage.signup(user.name, user.email);
    await expect(signupPage.getAccountInformationHeading()).toBeVisible();

    await signupPage.fillAccountInformation(user);
    await signupPage.createAccount();

    await expect(accountCreatedPage.getAccountCreatedHeading()).toBeVisible();
    await accountCreatedPage.clickContinue();

    await expect(accountCreatedPage.getLoggedInAsLabel()).toContainText(user.name);

    await accountCreatedPage.clickDeleteAccount();

    await expect(accountDeletedPage.getAccountDeletedHeading()).toBeVisible();
  });
});
