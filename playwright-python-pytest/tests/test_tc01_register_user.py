import allure
from playwright.sync_api import expect

from pages.account_pages import AccountCreatedPage, AccountDeletedPage
from pages.components.header import Header
from pages.login_page import LoginPage
from utils.data_generator import DataGenerator


@allure.feature("Authentication")
@allure.title("Register a new user, then delete the account")
def test_register_user(login_page: LoginPage, data: DataGenerator):
    user = data.new_user()
    page = login_page.page
    account_created = AccountCreatedPage(page)
    account_deleted = AccountDeletedPage(page)

    with allure.step("Register a new account"):
        login_page.open()
        login_page.register(user)

    with allure.step("The account is created and the new user is logged in"):
        expect(page.locator(AccountCreatedPage.HEADING)).to_be_visible()
        account_created.click_continue()
        expect(page.locator(Header.LOGGED_IN_AS)).to_contain_text(user.name)

    with allure.step("Delete the account"):
        login_page.header.delete_account()
        expect(page.locator(AccountDeletedPage.HEADING)).to_be_visible()
        account_deleted.click_continue()
