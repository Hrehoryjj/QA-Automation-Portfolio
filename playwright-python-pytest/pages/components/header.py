import allure
from playwright.sync_api import Page

from utils.allure_helpers import attach_screenshot


class Header:
    SIGNUP_LOGIN = "a[href='/login']"
    LOGOUT = "a[href='/logout']"
    DELETE_ACCOUNT = "a[href='/delete_account']"
    LOGGED_IN_AS = "a:has-text('Logged in as')"
    PRODUCTS = "a[href='/products']"
    CART = "a[href='/view_cart']"

    def __init__(self, page: Page) -> None:
        self.page = page

    def go_to_signup_login(self) -> None:
        with allure.step("Header: open Signup / Login"):
            self.page.click(self.SIGNUP_LOGIN)

    def logout(self) -> None:
        with allure.step("Header: log out"):
            self.page.click(self.LOGOUT)

    def delete_account(self) -> None:
        with allure.step("Header: delete account"):
            self.page.click(self.DELETE_ACCOUNT)
            attach_screenshot(self.page, "Account deleted")

    def go_to_products(self) -> None:
        with allure.step("Header: go to Products page"):
            self.page.click(self.PRODUCTS)

    def go_to_cart(self) -> None:
        with allure.step("Header: go to Cart page"):
            self.page.click(self.CART)
