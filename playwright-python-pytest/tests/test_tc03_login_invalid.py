import allure
from playwright.sync_api import expect

from pages.components.header import Header
from pages.login_page import LoginPage
from utils.data_generator import DataGenerator


@allure.feature("Authentication")
@allure.title("Log in with an incorrect email and password")
def test_login_with_invalid_credentials(login_page: LoginPage, data: DataGenerator):
    page = login_page.page

    with allure.step("Submit credentials that do not belong to any account"):
        login_page.open()
        login_page.login(data.random_email(), "wrong-password")

    with allure.step("An error is shown and the user stays logged out"):
        error = page.locator(LoginPage.LOGIN_ERROR)
        expect(error).to_be_visible()
        expect(error).to_contain_text("incorrect")
        expect(page.locator(Header.LOGGED_IN_AS)).to_have_count(0)
