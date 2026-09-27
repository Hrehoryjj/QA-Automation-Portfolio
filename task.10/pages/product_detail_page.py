import allure

from pages.base_page import BasePage
from utils.allure_helpers import attach_screenshot


class ProductDetailPage(BasePage):
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

    def add_review(self, name: str, email: str, text: str) -> None:
        with allure.step(f"Add a product review as {name} <{email}>"):
            self.page.fill(self.REVIEW_NAME, name)
            self.page.fill(self.REVIEW_EMAIL, email)
            self.page.fill(self.REVIEW_TEXT, text)
            attach_screenshot(self.page, "Review form filled")
            self.page.click(self.REVIEW_SUBMIT)
