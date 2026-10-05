import allure
from playwright.sync_api import Locator

from pages.base_page import BasePage
from utils.allure_helpers import attach_screenshot

ACCOUNT_CREATED_HEADING = "b:has-text('Account Created!')"
ACCOUNT_CREATED_CONTINUE_BUTTON = "a[data-qa='continue-button']"
ACCOUNT_DELETED_HEADING = "b:has-text('Account Deleted!')"
ACCOUNT_DELETED_CONTINUE_BUTTON = "a[data-qa='continue-button']"


class AccountCreatedPage(BasePage):
    URL_PATH = "/account_created"

    def heading(self) -> Locator:
        return self.page.locator(ACCOUNT_CREATED_HEADING)

    def click_continue(self) -> None:
        with allure.step("Continue after account creation"):
            attach_screenshot(self.page, "Account created")
            self.page.click(ACCOUNT_CREATED_CONTINUE_BUTTON)


class AccountDeletedPage(BasePage):
    URL_PATH = "/delete_account"

    def heading(self) -> Locator:
        return self.page.locator(ACCOUNT_DELETED_HEADING)

    def click_continue(self) -> None:
        with allure.step("Continue after account deletion"):
            attach_screenshot(self.page, "Account deleted")
            self.page.click(ACCOUNT_DELETED_CONTINUE_BUTTON)
