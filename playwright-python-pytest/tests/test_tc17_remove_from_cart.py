import allure
from playwright.sync_api import expect

from pages.cart_page import CartPage
from pages.products_page import ProductsPage


@allure.feature("Cart")
@allure.title("Remove a product from the cart")
def test_remove_product_from_cart(products_page: ProductsPage):
    page = products_page.page
    cart_page = CartPage(page)

    with allure.step("Add one product and open the cart"):
        products_page.open()
        products_page.add_product_to_cart(0)
        products_page.go_to_cart_from_modal()
        expect(cart_page.rows()).to_have_count(1)

    with allure.step("Remove the product"):
        cart_page.remove_product(0)

    with allure.step("The cart is empty"):
        expect(page.locator(CartPage.EMPTY_CART)).to_be_visible()
        expect(cart_page.rows()).to_have_count(0)
