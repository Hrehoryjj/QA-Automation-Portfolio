import allure
from playwright.sync_api import expect

from pages.products_page import ProductsPage
from utils.allure_helpers import attach_screenshot

SEARCH_TERM = "dress"


@allure.feature("Products")
@allure.title("Search returns products relevant to the query")
def test_search_product(products_page: ProductsPage):
    with allure.step("Open the Products page"):
        products_page.open()
        expect(products_page.page.locator(ProductsPage.ALL_PRODUCTS_HEADING)).to_be_visible()

    products_page.search(SEARCH_TERM)

    with allure.step("Searched Products section shows relevant results"):
        expect(products_page.page.locator(ProductsPage.SEARCHED_PRODUCTS_HEADING)).to_be_visible()

        cards = products_page.cards()
        expect(cards).not_to_have_count(0)

        names = cards.locator(ProductsPage.PRODUCT_NAME).all_inner_texts()
        assert any(SEARCH_TERM.lower() in name.lower() for name in names), names
        attach_screenshot(products_page.page, "Filtered search results", full_page=True)
