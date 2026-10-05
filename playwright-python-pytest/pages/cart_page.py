import allure
from playwright.sync_api import Locator

from pages.base_page import BasePage
from utils.allure_helpers import attach_screenshot
from utils.text import clean

CART_ROWS = "#cart_info tbody tr"
ROW_NAME = "td.cart_description h4 a"
ROW_PRICE = "td.cart_price p"
ROW_QUANTITY = "td.cart_quantity button"
ROW_TOTAL = "td.cart_total p"
DELETE_BUTTON = "a.cart_quantity_delete"
PROCEED_TO_CHECKOUT = "a.check_out"
EMPTY_CART = "#empty_cart"
REGISTER_LOGIN_LINK = "div.modal-content a[href='/login']"


class CartPage(BasePage):
    URL_PATH = "/view_cart"

    def rows(self) -> Locator:
        return self.page.locator(CART_ROWS)

    def row_details(self) -> list[dict[str, str]]:
        return [
            {
                "name": clean(row.locator(ROW_NAME).inner_text()),
                "price": clean(row.locator(ROW_PRICE).inner_text()),
                "quantity": clean(row.locator(ROW_QUANTITY).inner_text()),
                "total": clean(row.locator(ROW_TOTAL).inner_text()),
            }
            for row in self.rows().all()
        ]

    def empty_cart(self) -> Locator:
        return self.page.locator(EMPTY_CART)

    def remove_product(self, index: int = 0) -> None:
        with allure.step(f"Remove product #{index + 1} from the cart"):
            self.page.locator(DELETE_BUTTON).nth(index).click()
            attach_screenshot(self.page, "Product removed from cart")

    def proceed_to_checkout(self) -> None:
        with allure.step("Proceed to checkout"):
            self.page.click(PROCEED_TO_CHECKOUT)

    def checkout_register_or_login(self) -> None:
        with allure.step("Choose 'Register / Login account' from the checkout modal"):
            self.page.click(REGISTER_LOGIN_LINK)
