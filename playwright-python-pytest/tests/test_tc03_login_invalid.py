import allure
from playwright.sync_api import expect

from pages.login_page import LoginPage
from utils.data_generator import DataGenerator


@allure.feature("Authentication")
@allure.title("Log in with an incorrect email and password")
def test_login_with_invalid_credentials(login_page: LoginPage, data: DataGenerator):
    with allure.step("Submit credentials that do not belong to any account"):
        login_page.open()
        expect(login_page.login_heading()).to_have_text("Login to your account")
        login_page.login(data.random_email(), "wrong-password")

    with allure.step("An error is shown and the user stays logged out"):
        expect(login_page.login_error()).to_have_text("Your email or password is incorrect!")
        expect(login_page.header.logged_in_as()).to_have_count(0)
