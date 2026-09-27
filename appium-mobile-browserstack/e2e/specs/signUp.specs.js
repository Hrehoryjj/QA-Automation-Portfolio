const LoginPage = require('../pages/login.page');
const { randomEmail, randomPassword } = require('../data/generator');

describe('TC-05: Sign up with random credentials', () => {
  it('should successfully sign up with generated email and password', async () => {
    const email = await randomEmail();
    const password = await randomPassword();

    await LoginPage.openLoginScreen();
    await LoginPage.switchToSignUp();
    await LoginPage.fillSignUpForm(email, password);

    expect(await LoginPage.getEmailValue()).toBe(email);

    const passwordValue = await LoginPage.getPasswordValue();
    const confirmPasswordValue = await LoginPage.getConfirmPasswordValue();
    expect(passwordValue).toBe(confirmPasswordValue);
    expect(passwordValue).toHaveLength(password.length);

    await LoginPage.submitSignUp();
    await LoginPage.waitForSuccessAlert(15000);

    const alertVisible = await LoginPage.isSuccessAlertDisplayed();
    expect(alertVisible).toBe(true);

    const message = await LoginPage.getSuccessAlertText();
    expect(message).toBe('You successfully signed up!');

    await LoginPage.dismissSuccessAlert();
  });
});