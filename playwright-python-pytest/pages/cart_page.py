import allure

from pages.base_page import BasePage
from utils.allure_helpers import attach_screenshot


class CartPage(BasePage):
    URL_PATH = "/view_cart"

    CART_ROWS = "#cart_info tbody tr"
    ROW_NAME = "td.cart_description h4 a"
    ROW_PRICE = "td.cart_price p"
    ROW_QUANTITY = "td.cart_quantity button"
    ROW_TOTAL = "td.cart_total p"
    DELETE_BUTTON = "a.cart_quantity_delete"
    PROCEED_TO_CHECKOUT = "a.check_out"
    EMPTY_CART = "#empty_cart"
    REGISTER_LOGIN_LINK = "div.modal-content a[href='/login']"

    def rows(self):
        return self.page.locator(self.CART_ROWS)

    def remove_product(self, index: int = 0) -> None:
        with allure.step(f"Remove product #{index + 1} from the cart"):
            self.page.locator(self.DELETE_BUTTON).nth(index).click()
            attach_screenshot(self.page, "Product removed from cart")

    def proceed_to_checkout(self) -> None:
        with allure.step("Proceed to checkout"):
            self.page.click(self.PROCEED_TO_CHECKOUT)

    def checkout_register_or_login(self) -> None:
        with allure.step("Choose 'Register / Login account' from the checkout modal"):
            self.page.click(self.REGISTER_LOGIN_LINK)
