import allure
from playwright.sync_api import expect

from pages.cart_page import CartPage
from pages.products_page import ProductsPage


def _normalize(values: list[str]) -> list[str]:
    return sorted(" ".join(value.split()) for value in values)


@allure.feature("Cart")
@allure.title("Add two products to the cart")
def test_add_products_to_cart(products_page: ProductsPage):
    page = products_page.page
    cart_page = CartPage(page)

    with allure.step("Remember the first two product names"):
        products_page.open()
        names = products_page.cards().locator(ProductsPage.PRODUCT_NAME)
        expected = [names.nth(0).inner_text(), names.nth(1).inner_text()]

    with allure.step("Add both products to the cart"):
        products_page.add_product_to_cart(0)
        products_page.continue_shopping()
        products_page.add_product_to_cart(1)
        products_page.go_to_cart_from_modal()

    with allure.step("Both products are listed in the cart"):
        expect(cart_page.rows()).to_have_count(2)
        cart_names = cart_page.rows().locator(CartPage.ROW_NAME)
        assert _normalize(cart_names.all_inner_texts()) == _normalize(expected)
