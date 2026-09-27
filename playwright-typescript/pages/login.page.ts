import { BasePage } from './base.page';
import { Page, Locator} from '@playwright/test';

export class LoginPage extends BasePage {
    constructor(page: Page) {
        super(page);
    }
    async navigateToLoginPage() {
        await this.navigate('/login');
    }

    get usernameField() {
        return this.page.locator('#username');
    }     
    get passwordField() {    
        return this.page.locator('#password');
    }
    get loginButton() {
        return this.page.locator('#login-submit');
    }   
    async login(username: string, password: string) {
        await this.usernameField.fill(username);
        await this.passwordField.fill(password);
        await this.loginButton.click();
    }
};