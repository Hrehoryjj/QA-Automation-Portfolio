import allure

from pages.base_page import BasePage
from pages.signup_page import SignupPage
from utils.allure_helpers import attach_screenshot
from utils.data_generator import UserData


class LoginPage(BasePage):
    URL_PATH = "/login"

    LOGIN_HEADING = "div.login-form h2"
    EMAIL_INPUT = "input[data-qa='login-email']"
    PASSWORD_INPUT = "input[data-qa='login-password']"
    LOGIN_BUTTON = "button[data-qa='login-button']"
    LOGIN_ERROR = "div.login-form p"

    SIGNUP_HEADING = "div.signup-form h2"
    SIGNUP_NAME_INPUT = "input[data-qa='signup-name']"
    SIGNUP_EMAIL_INPUT = "input[data-qa='signup-email']"
    SIGNUP_BUTTON = "button[data-qa='signup-button']"

    def login(self, email: str, password: str) -> None:
        with allure.step(f"Log in as {email}"):
            self.page.fill(self.EMAIL_INPUT, email)
            self.page.fill(self.PASSWORD_INPUT, password)
            attach_screenshot(self.page, "Login form filled")
            self.page.click(self.LOGIN_BUTTON)

    def start_signup(self, name: str, email: str) -> None:
        with allure.step(f"Start signup for {name} <{email}>"):
            self.page.fill(self.SIGNUP_NAME_INPUT, name)
            self.page.fill(self.SIGNUP_EMAIL_INPUT, email)
            attach_screenshot(self.page, "Signup form filled")
            self.page.click(self.SIGNUP_BUTTON)

    def register(self, user: UserData) -> None:
        with allure.step(f"Register account for {user.name}"):
            self.start_signup(user.name, user.email)
            signup_page = SignupPage(self.page)
            signup_page.fill_account_info(user)
            signup_page.create_account()
