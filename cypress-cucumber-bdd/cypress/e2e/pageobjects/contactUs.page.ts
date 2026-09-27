import { BasePage } from './base.page';

export class ContactUsPage extends BasePage {

    visitContactUs(): void {
        this.navigateTo('/contact-us');
    }
    getContactFormField(selector: string) {
        return cy.get(selector);
    }
    private static readonly BANNER_COOKIE_BUTTON = '#onetrust-pc-btn-handler';
    private static readonly FLOATING_COOKIE_BUTTON = '.ot-floating-button__open, .ot-floating-button__close';
    private static readonly COOKIE_TRIGGER_SELECTOR =
        `${ContactUsPage.BANNER_COOKIE_BUTTON}, ${ContactUsPage.FLOATING_COOKIE_BUTTON}`;

    detectCoockiesettings() {
        return cy.get(ContactUsPage.COOKIE_TRIGGER_SELECTOR).filter(':visible');
    }
    // The OneTrust consent widget only renders for regions/sessions OneTrust
    // flags as needing consent, which varies with the CI runner's IP - not
    // something the test controls (same behavior task.7's TC-20 documents).
    // Poll for it instead of asserting immediately, and report whether it
    // showed up at all so the caller can skip verification gracefully.
    isCookieWidgetPresent(timeoutMs = 4000): Cypress.Chainable<boolean> {
        const deadline = Date.now() + timeoutMs;
        const poll = (): Cypress.Chainable<boolean> =>
            cy.get('body').then(($body) => {
                if ($body.find(ContactUsPage.COOKIE_TRIGGER_SELECTOR).filter(':visible').length > 0) {
                    return true;
                }
                if (Date.now() >= deadline) {
                    return false;
                }
                return cy.wait(250).then(poll);
            });
        return poll();
    }
    clickCookieSettings() {
        this.detectCoockiesettings().first().click({ force: true });
    }
    acceptConfirmChoicesButton(){
        return cy.contains('button.save-preference-btn-handler', 'Confirm My Choices');
    }
    getReasonForContactDropdown() {
        return cy.get('select[name="Reason_for_Contact__c"]');
    }
    getCookeSettingsPanel() {
        return cy.get('#ot-pc-content');
    }
    private static readonly FORM_FIELDS_SELECTOR = '#mktoForm_1987 input[type="text"], #mktoForm_1987 input[type="email"]';
    private static readonly SUBMIT_BUTTON_SELECTOR = 'button[type="submit"]';
    getFormFields() {
        return cy.get(ContactUsPage.FORM_FIELDS_SELECTOR);
    }
    getSubmitButton() {
        return cy.get(ContactUsPage.SUBMIT_BUTTON_SELECTOR);
    }
}
