import allure
from playwright.sync_api import expect

from pages.components.header import Header
from pages.home_page import HomePage


@allure.feature("Authentication")
@allure.title("Log in with a valid email and password")
def test_login_with_valid_credentials(logged_in_page: HomePage):
    page = logged_in_page.page

    with allure.step("The account is logged in"):
        expect(page.locator(Header.LOGGED_IN_AS)).to_be_visible()
        expect(page.locator(Header.LOGOUT)).to_be_visible()
