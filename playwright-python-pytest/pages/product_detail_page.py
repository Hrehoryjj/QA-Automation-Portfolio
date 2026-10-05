import allure
from playwright.sync_api import Locator

from pages.base_page import BasePage
from utils.allure_helpers import attach_screenshot

NAME = "div.product-information h2"
CATEGORY = "div.product-information p:has-text('Category')"
PRICE = "div.product-information span span"
AVAILABILITY = "div.product-information p:has-text('Availability')"
CONDITION = "div.product-information p:has-text('Condition')"
BRAND = "div.product-information p:has-text('Brand')"
REVIEW_NAME = "#name"
REVIEW_EMAIL = "#email"
REVIEW_TEXT = "#review"
REVIEW_SUBMIT = "#button-review"
REVIEW_SUCCESS = "#review-section .alert-success"


class ProductDetailPage(BasePage):
    def name(self) -> Locator:
        return self.page.locator(NAME)

    def info_fields(self) -> list[Locator]:
        selectors = (NAME, CATEGORY, PRICE, AVAILABILITY, CONDITION, BRAND)
        return [self.page.locator(selector) for selector in selectors]

    def review_success(self) -> Locator:
        return self.page.locator(REVIEW_SUCCESS)

    def add_review(self, name: str, email: str, text: str) -> None:
        with allure.step(f"Add a product review as {name} <{email}>"):
            self.page.fill(REVIEW_NAME, name)
            self.page.fill(REVIEW_EMAIL, email)
            self.page.fill(REVIEW_TEXT, text)
            attach_screenshot(self.page, "Review form filled")
            self.page.click(REVIEW_SUBMIT)
