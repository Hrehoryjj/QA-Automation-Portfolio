import { LoginPage } from "../../pages/login.page";
import { test, expect } from "@playwright/test"; 
import testUser from "../../test-data/testUser.json";

test.describe("Login Page", () => {
  let loginPage: LoginPage;

  test.beforeEach(async ({ page }) => {
    loginPage = new LoginPage(page);
    await loginPage.navigateToLoginPage();
  });

  test("Login with valid credentials", async ({ page }) => {
    await loginPage.login(testUser.username, testUser.password); 
    await expect(page).toHaveURL("https://www.redmine.org/my/twofa/totp/activate/confirm");
  });

  test("Login with empty credentials", async ({ page }) => {
    await loginPage.login("", ""); 
    await expect(page.locator("#flash_error")).toBeVisible();
  });

  test("Login with invalid credentials", async ({ page }) => {
    await loginPage.login("123", testUser.password); 
    await expect(page.locator("#flash_error")).toBeVisible();
  });
});
