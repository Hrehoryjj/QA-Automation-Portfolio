import { test, expect } from '../fixtures/test';
import { HomePage } from '../pageObjects/HomePage';
import { generateSubscriptionEmail } from '../testData/subscriptionData';

test('TC-05 Verify Subscription in home page', async ({ page }) => {
  const homePage = new HomePage(page);

  await homePage.goto();
  await homePage.scrollToFooter();

  await expect(homePage.getSubscriptionHeading()).toHaveText(/subscription/i);

  await homePage.enterSubscriptionEmail(generateSubscriptionEmail());
  await homePage.clickSubscribeButton();

  await expect(homePage.getSubscriptionSuccessMessage()).toBeVisible();
  await expect(homePage.getSubscriptionSuccessMessage()).toHaveText(
    'You have been successfully subscribed!',
  );
});
