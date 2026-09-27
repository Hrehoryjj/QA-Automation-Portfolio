import allure

from pages.base_page import BasePage
from utils.allure_helpers import attach_screenshot


class ProductsPage(BasePage):
    URL_PATH = "/products"

    ALL_PRODUCTS_HEADING = "h2.title:has-text('All Products')"
    SEARCHED_PRODUCTS_HEADING = "h2.title:has-text('Searched Products')"
    SEARCH_INPUT = "#search_product"
    SEARCH_BUTTON = "#submit_search"

    PRODUCT_CARDS = "div.features_items div.product-image-wrapper"
    PRODUCT_NAME = "div.productinfo p"
    VIEW_PRODUCT_LINK = "a:has-text('View Product')"
    ADD_TO_CART = "div.productinfo a.add-to-cart"

    CART_MODAL = "#cartModal"
    CONTINUE_SHOPPING_BUTTON = "#cartModal button:has-text('Continue Shopping')"
    VIEW_CART_LINK = "#cartModal a[href='/view_cart']"

    def search(self, term: str) -> None:
        with allure.step(f"Search products for '{term}'"):
            self.page.fill(self.SEARCH_INPUT, term)
            self.page.click(self.SEARCH_BUTTON)
            attach_screenshot(self.page, f"Search results for '{term}'")

    def cards(self):
        return self.page.locator(self.PRODUCT_CARDS)

    def open_product(self, index: int = 0) -> None:
        with allure.step(f"Open detail page of product #{index + 1}"):
            self.page.locator(self.VIEW_PRODUCT_LINK).nth(index).click()

    def add_product_to_cart(self, index: int = 0) -> None:
        with allure.step(f"Add product #{index + 1} to the cart"):
            self.page.locator(self.PRODUCT_CARDS).nth(index).locator(self.ADD_TO_CART).click()
            self.page.locator(self.CART_MODAL).wait_for(state="visible")
            attach_screenshot(self.page, "Product added to cart")

    def continue_shopping(self) -> None:
        with allure.step("Dismiss the cart modal (Continue Shopping)"):
            self.page.click(self.CONTINUE_SHOPPING_BUTTON)
            self.page.locator(self.CART_MODAL).wait_for(state="hidden")

    def go_to_cart_from_modal(self) -> None:
        with allure.step("Open the cart from the cart modal"):
            self.page.click(self.VIEW_CART_LINK)
