import allure
from playwright.sync_api import expect

from pages.home_page import HomePage


@allure.feature("Authentication")
@allure.title("Log in with a valid email and password")
def test_login_with_valid_credentials(logged_in_page: HomePage):
    with allure.step("The account is logged in"):
        expect(logged_in_page.header.logged_in_as()).to_contain_text("Logged in as")
        expect(logged_in_page.header.logout_link()).to_be_visible()
