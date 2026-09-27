import allure

from pages.base_page import BasePage
from utils.allure_helpers import attach_screenshot


class CheckoutPage(BasePage):
    URL_PATH = "/checkout"

    DELIVERY_ADDRESS = "#address_delivery"
    INVOICE_ADDRESS = "#address_invoice"
    ORDER_ITEMS = "#cart_info tbody tr"
    COMMENT = "textarea[name='message']"
    PLACE_ORDER_BUTTON = "a[href='/payment']"

    def add_comment(self, text: str) -> None:
        with allure.step("Add an order comment"):
            self.page.fill(self.COMMENT, text)

    def place_order(self) -> None:
        with allure.step("Place the order"):
            attach_screenshot(self.page, "Order review before placing")
            self.page.click(self.PLACE_ORDER_BUTTON)
