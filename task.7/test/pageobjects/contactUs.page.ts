import BasePage from './base.page';
import { randomData } from '../utils/randomData';
import validUser from '../data/users.json';

class ContactUsPage extends BasePage {
  private static readonly FORM_FIELDS_SELECTOR =
    '#mktoForm_1987 input[type="text"], #mktoForm_1987 input[type="email"]';
  private static readonly SUBMIT_BUTTON_SELECTOR = 'button[type="submit"]';
  private static readonly CONFIRM_CHOICES_BUTTON = 'button.save-preference-btn-handler*=Confirm My Choices';
  private static readonly REASON_DROPDOWN = 'select[name="Reason_for_Contact__c"]';
  private static readonly COOKIE_SETTINGS_PANEL = '#ot-pc-content';
  private static readonly BANNER_COOKIE_BUTTON = '#onetrust-pc-btn-handler';
  private static readonly FLOATING_COOKIE_BUTTON = '.ot-floating-button__open';
  private static readonly OPTION_TAG = 'option';

  private get confirmChoicesButton() {
    return $(ContactUsPage.CONFIRM_CHOICES_BUTTON);
  }

  private get reasonForContactDropdown() {
    return $(ContactUsPage.REASON_DROPDOWN);
  }

  private get cookieSettingsPanel() {
    return $(ContactUsPage.COOKIE_SETTINGS_PANEL);
  }

  private get formFields() {
    return $$(ContactUsPage.FORM_FIELDS_SELECTOR);
  }

  private get submitButton() {
    return $(ContactUsPage.SUBMIT_BUTTON_SELECTOR);
  }

  async visitContactUs() {
    await this.navigateTo('/contact-us');
  }

  async isSubmitButtonClickable() {
    const button = await this.submitButton;
    await this.safeScrollIntoView(button);
    return button.isClickable();
  }

  async getReasonDropdownOptionsCount() {
    const options = await this.reasonForContactDropdown.$$(ContactUsPage.OPTION_TAG);
    return options.length;
  }

  async allFormFieldsAcceptValue(value: string): Promise<boolean> {
    const fields = await this.formFields;
    for (const field of fields) {
      const name = await field.getAttribute('name');
      let fieldValue = value;
      if (name === 'Phone_Number_Base__c') fieldValue = validUser.validContactUser.phone;
      if (name === 'Email') fieldValue = validUser.validContactUser.email;
      if (name === 'Website') fieldValue = randomData.companyName();

      await field.setValue(fieldValue);
      if ((await field.getValue()) !== fieldValue) return false;
      await field.clearValue();
    }
    return true;
  }

  async clickCookieSettings(): Promise<boolean> {
    const bannerButton = $(ContactUsPage.BANNER_COOKIE_BUTTON);
    const floatingButton = $(ContactUsPage.FLOATING_COOKIE_BUTTON);

    const appeared = await browser
      .waitUntil(async () => (await bannerButton.isExisting()) || (await floatingButton.isExisting()), {
        timeout: 4000,
        timeoutMsg: '',
      })
      .catch(() => false);

    if (!appeared) return false;

    const activeSelector = (await bannerButton.isExisting())
      ? ContactUsPage.BANNER_COOKIE_BUTTON
      : ContactUsPage.FLOATING_COOKIE_BUTTON;

    await browser.execute((s) => (document.querySelector(s) as HTMLElement)?.click(), activeSelector);
    await this.cookieSettingsPanel.waitForExist({ timeout: 4000 });
    return true;
  }

  async isCookieSettingsPanelDisplayed() {
    return this.cookieSettingsPanel.isDisplayed();
  }

  async isConfirmChoicesButtonClickable() {
    return this.confirmChoicesButton.isClickable();
  }
}

export default new ContactUsPage();