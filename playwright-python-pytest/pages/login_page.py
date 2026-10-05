import allure
from playwright.sync_api import Locator

from pages.base_page import BasePage
from pages.signup_page import SignupPage
from utils.allure_helpers import attach_screenshot
from utils.data_generator import UserData

LOGIN_HEADING = "div.login-form h2"
EMAIL_INPUT = "input[data-qa='login-email']"
PASSWORD_INPUT = "input[data-qa='login-password']"
LOGIN_BUTTON = "button[data-qa='login-button']"
LOGIN_ERROR = "div.login-form p"
SIGNUP_HEADING = "div.signup-form h2"
SIGNUP_NAME_INPUT = "input[data-qa='signup-name']"
SIGNUP_EMAIL_INPUT = "input[data-qa='signup-email']"
SIGNUP_BUTTON = "button[data-qa='signup-button']"


class LoginPage(BasePage):
    URL_PATH = "/login"

    def login_heading(self) -> Locator:
        return self.page.locator(LOGIN_HEADING)

    def signup_heading(self) -> Locator:
        return self.page.locator(SIGNUP_HEADING)

    def login_error(self) -> Locator:
        return self.page.locator(LOGIN_ERROR)

    def login(self, email: str, password: str) -> None:
        with allure.step(f"Log in as {email}"):
            self.page.fill(EMAIL_INPUT, email)
            self.page.fill(PASSWORD_INPUT, password)
            attach_screenshot(self.page, "Login form filled")
            self.page.click(LOGIN_BUTTON)

    def start_signup(self, name: str, email: str) -> None:
        with allure.step(f"Start signup for {name} <{email}>"):
            self.page.fill(SIGNUP_NAME_INPUT, name)
            self.page.fill(SIGNUP_EMAIL_INPUT, email)
            attach_screenshot(self.page, "Signup form filled")
            self.page.click(SIGNUP_BUTTON)

    def register(self, user: UserData) -> None:
        with allure.step(f"Register account for {user.name}"):
            self.start_signup(user.name, user.email)
            signup_page = SignupPage(self.page)
            signup_page.fill_account_info(user)
            signup_page.create_account()
