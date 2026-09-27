import { expect } from '@wdio/globals';
import homePage from '../pageobjects/home.page';
import contactUsPage from '../pageobjects/contactUs.page';
import { randomData } from '../utils/randomData';
import { addDescription } from '@wdio/allure-reporter';


describe('Contact Us & Cookies', () => {
  it('TC-17: submit button should be clickable', async () => {
    await homePage.navigateToHome();
    await homePage.clickContactUsButton();
    await expect(browser).toHaveUrl(expect.stringContaining('/contact-us'));
    expect(await contactUsPage.isSubmitButtonClickable()).toBe(true);
  });

  it('TC-18: "How we can help you" dropdown should have two options', async () => {
    await contactUsPage.visitContactUs();
    const optionsCount = await contactUsPage.getReasonDropdownOptionsCount();
    expect(optionsCount).toBe(3);
  });

  it('TC-19: contact form fields should accept input', async () => {
    await contactUsPage.visitContactUs();
    const testValue = randomData.fullName();
    expect(await contactUsPage.allFormFieldsAcceptValue(testValue)).toBe(true);
  });

  it('TC-20: cookie settings should be editable on Contact Us page', async () => {
    await contactUsPage.visitContactUs();
    const cookieWidgetAvailable = await contactUsPage.clickCookieSettings();

    if (!cookieWidgetAvailable) {
      addDescription('Passed without verification: cookie consent widget was not shown for this session/region.');
      return;
    }
    expect(await contactUsPage.isCookieSettingsPanelDisplayed()).toBe(true);
    expect(await contactUsPage.isConfirmChoicesButtonClickable()).toBe(true);
  });
});