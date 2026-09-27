import allure

from pages.base_page import BasePage
from utils.allure_helpers import attach_screenshot


class AccountCreatedPage(BasePage):
    URL_PATH = "/account_created"

    HEADING = "b:has-text('Account Created!')"
    CONTINUE_BUTTON = "a[data-qa='continue-button']"

    def click_continue(self) -> None:
        with allure.step("Continue after account creation"):
            attach_screenshot(self.page, "Account created")
            self.page.click(self.CONTINUE_BUTTON)


class AccountDeletedPage(BasePage):
    URL_PATH = "/delete_account"

    HEADING = "b:has-text('Account Deleted!')"
    CONTINUE_BUTTON = "a[data-qa='continue-button']"

    def click_continue(self) -> None:
        with allure.step("Continue after account deletion"):
            attach_screenshot(self.page, "Account deleted")
            self.page.click(self.CONTINUE_BUTTON)
