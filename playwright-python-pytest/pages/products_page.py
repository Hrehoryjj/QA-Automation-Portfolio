import allure
from playwright.sync_api import Locator

from pages.base_page import BasePage
from utils.allure_helpers import attach_screenshot
from utils.text import clean

ALL_PRODUCTS_HEADING = "h2.title:has-text('All Products')"
SEARCHED_PRODUCTS_HEADING = "h2.title:has-text('Searched Products')"
SEARCH_INPUT = "#search_product"
SEARCH_BUTTON = "#submit_search"
PRODUCT_CARDS = "div.features_items div.product-image-wrapper"
PRODUCT_NAME = "div.productinfo p"
PRODUCT_PRICE = "div.productinfo h2"
VIEW_PRODUCT_LINK = "a:has-text('View Product')"
ADD_TO_CART = "div.productinfo a.add-to-cart"
CART_MODAL = "#cartModal"
CONTINUE_SHOPPING_BUTTON = "#cartModal button:has-text('Continue Shopping')"
VIEW_CART_LINK = "#cartModal a[href='/view_cart']"


class ProductsPage(BasePage):
    URL_PATH = "/products"

    def search(self, term: str) -> None:
        with allure.step(f"Search products for '{term}'"):
            self.page.fill(SEARCH_INPUT, term)
            self.page.click(SEARCH_BUTTON)
            attach_screenshot(self.page, f"Search results for '{term}'")

    def all_products_heading(self) -> Locator:
        return self.page.locator(ALL_PRODUCTS_HEADING)

    def searched_products_heading(self) -> Locator:
        return self.page.locator(SEARCHED_PRODUCTS_HEADING)

    def cards(self) -> Locator:
        return self.page.locator(PRODUCT_CARDS)

    def product_ids(self) -> list[int]:
        ids = self.cards().locator(ADD_TO_CART).evaluate_all("links => links.map(link => link.dataset.productId)")
        return [int(product_id) for product_id in ids]

    def product_summary(self, index: int) -> dict[str, str]:
        card = self.cards().nth(index)
        return {
            "name": clean(card.locator(PRODUCT_NAME).inner_text()),
            "price": clean(card.locator(PRODUCT_PRICE).inner_text()),
        }

    def open_product(self, index: int = 0) -> None:
        with allure.step(f"Open detail page of product #{index + 1}"):
            self.page.locator(VIEW_PRODUCT_LINK).nth(index).click()

    def add_product_to_cart(self, index: int = 0) -> None:
        with allure.step(f"Add product #{index + 1} to the cart"):
            self.page.locator(PRODUCT_CARDS).nth(index).locator(ADD_TO_CART).click()
            self.page.locator(CART_MODAL).wait_for(state="visible")
            attach_screenshot(self.page, "Product added to cart")

    def continue_shopping(self) -> None:
        with allure.step("Dismiss the cart modal (Continue Shopping)"):
            self.page.click(CONTINUE_SHOPPING_BUTTON)
            self.page.locator(CART_MODAL).wait_for(state="hidden")

    def go_to_cart_from_modal(self) -> None:
        with allure.step("Open the cart from the cart modal"):
            self.page.click(VIEW_CART_LINK)
