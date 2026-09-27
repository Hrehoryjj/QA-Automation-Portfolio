const BasePage = require('./base.page');

const SELECTORS = {
  navLoginButton: '~Login',
  signUpTab: '~button-sign-up-container',
  emailInput: '~input-email',
  passwordInput: '~input-password',
  confirmPasswordInput: '~input-repeat-password',
  signUpButton: '~button-SIGN UP',
  successAlertTitle: '//*[@resource-id="android:id/alertTitle"]',
  successAlertMessage: '//*[@resource-id="android:id/message"]',
  successOkButton: '//*[@resource-id="android:id/button1"]',
};

class LoginPage extends BasePage {
  async openLoginScreen() {
    await this.tap(SELECTORS.navLoginButton);
  }

  async switchToSignUp() {
    await this.tap(SELECTORS.signUpTab);
  }

  async fillSignUpForm(email, password) {
    await this.setValue(SELECTORS.emailInput, email);
    await this.setValue(SELECTORS.passwordInput, password);
    await this.setValue(SELECTORS.confirmPasswordInput, password);
  }

  async submitSignUp() {
    await this.tap(SELECTORS.signUpButton);
  }

  async getEmailValue() {
    return this.getText(SELECTORS.emailInput);
  }

  async getPasswordValue() {
    return this.getText(SELECTORS.passwordInput);
  }

  async getConfirmPasswordValue() {
    return this.getText(SELECTORS.confirmPasswordInput);
  }

  async waitForSuccessAlert(timeout = 15000) {
    return this.waitUntilDisplayed(SELECTORS.successAlertTitle, timeout);
  }

  async isSuccessAlertDisplayed() {
    return this.isDisplayed(SELECTORS.successAlertTitle);
  }

  async getSuccessAlertText() {
    return this.getText(SELECTORS.successAlertMessage);
  }

  async dismissSuccessAlert() {
    await this.tap(SELECTORS.successOkButton);
  }
}

module.exports = new LoginPage();
