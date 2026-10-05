import allure
from playwright.sync_api import expect

from pages.products_page import ProductsPage
from utils.allure_helpers import attach_screenshot

SEARCH_TERM = "dress"
SEARCH_API = "/api/searchProduct"


@allure.feature("Products")
@allure.title("Search returns exactly the products the catalogue has for the query")
def test_search_product(products_page: ProductsPage):
    with allure.step("Open the Products page"):
        products_page.open()
        expect(products_page.all_products_heading()).to_be_visible()
        catalogue_size = products_page.cards().count()

    with allure.step(f"Get the expected results for '{SEARCH_TERM}' from the search API"):
        response = products_page.page.request.post(SEARCH_API, form={"search_product": SEARCH_TERM})
        expected = sorted(product["name"] for product in response.json()["products"])
        assert 0 < len(expected) < catalogue_size, expected

    products_page.search(SEARCH_TERM)

    with allure.step("Searched Products shows exactly the expected products"):
        expect(products_page.searched_products_heading()).to_be_visible()
        expect(products_page.cards()).to_have_count(len(expected))
        assert sorted(products_page.product_names()) == expected
        attach_screenshot(products_page.page, "Filtered search results", full_page=True)
