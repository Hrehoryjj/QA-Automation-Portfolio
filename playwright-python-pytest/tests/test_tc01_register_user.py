import allure
from playwright.sync_api import expect

from pages.account_pages import AccountCreatedPage, AccountDeletedPage
from pages.home_page import HomePage
from pages.login_page import LoginPage
from pages.signup_page import SignupPage
from utils.data_generator import UserData


@allure.feature("Authentication")
@allure.title("Register a new user, then delete the account")
def test_register_user(home_page: HomePage, new_user: UserData):
    page = home_page.page
    login_page = LoginPage(page)
    signup_page = SignupPage(page)
    account_created = AccountCreatedPage(page)
    account_deleted = AccountDeletedPage(page)

    with allure.step("Open the home page and go to Signup / Login"):
        home_page.open()
        expect(home_page.slider_heading().first).to_be_visible()
        home_page.header.go_to_signup_login()
        expect(login_page.signup_heading()).to_have_text("New User Signup!")

    with allure.step("Fill the signup form and the account information"):
        login_page.start_signup(new_user.name, new_user.email)
        expect(signup_page.account_info_heading()).to_be_visible()
        signup_page.fill_account_info(new_user)
        signup_page.create_account()

    with allure.step("The account is created and the new user is logged in"):
        expect(account_created.heading()).to_be_visible()
        account_created.click_continue()
        expect(home_page.header.logged_in_as()).to_have_text(f"Logged in as {new_user.name}")

    with allure.step("Delete the account"):
        home_page.header.delete_account()
        expect(account_deleted.heading()).to_be_visible()
        account_deleted.click_continue()
