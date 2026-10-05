import allure
from playwright.sync_api import expect

from pages.cart_page import CartPage
from pages.products_page import ProductsPage


@allure.feature("Cart")
@allure.title("Add two products to the cart and verify price, quantity and total")
def test_add_products_to_cart(products_page: ProductsPage):
    cart_page = CartPage(products_page.page)

    with allure.step("Remember the first two products"):
        products_page.open()
        expected = [products_page.product_summary(0), products_page.product_summary(1)]

    with allure.step("Add both products to the cart"):
        products_page.add_product_to_cart(0)
        products_page.continue_shopping()
        products_page.add_product_to_cart(1)
        products_page.go_to_cart_from_modal()

    with allure.step("Each product is in the cart once, with its price and a matching total"):
        expect(cart_page.rows()).to_have_count(2)
        rows = cart_page.row_details()
        assert [{"name": r["name"], "price": r["price"]} for r in rows] == expected
        for row in rows:
            assert row["quantity"] == "1", row
            assert row["total"] == row["price"], row
