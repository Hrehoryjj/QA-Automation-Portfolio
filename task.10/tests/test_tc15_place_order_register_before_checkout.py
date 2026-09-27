import allure
from playwright.sync_api import expect

from pages.account_pages import AccountCreatedPage, AccountDeletedPage
from pages.cart_page import CartPage
from pages.checkout_page import CheckoutPage
from pages.login_page import LoginPage
from pages.payment_page import PaymentPage
from pages.products_page import ProductsPage


@allure.feature("Checkout")
@allure.title("Place an order, registering before checkout")
def test_place_order_register_before_checkout(products_page: ProductsPage, data):
    page = products_page.page
    cart_page = CartPage(page)
    login_page = LoginPage(page)
    account_deleted = AccountDeletedPage(page)
    checkout_page = CheckoutPage(page)
    payment_page = PaymentPage(page)

    user = data.new_user()
    payment = data.new_payment()

    with allure.step("Add a product and start checkout as a guest"):
        products_page.open()
        products_page.add_product_to_cart(0)
        products_page.go_to_cart_from_modal()
        cart_page.proceed_to_checkout()
        cart_page.checkout_register_or_login()

    with allure.step("Register a new account during checkout"):
        login_page.register(user)
        AccountCreatedPage(page).click_continue()

    with allure.step("Complete checkout and pay"):
        products_page.header.go_to_cart()
        cart_page.proceed_to_checkout()
        checkout_page.add_comment(data.contact_message())
        checkout_page.place_order()
        payment_page.pay(payment)

    with allure.step("The order is confirmed"):
        expect(page.locator(PaymentPage.ORDER_PLACED_HEADING)).to_be_visible()

    with allure.step("Clean up the created account"):
        products_page.header.delete_account()
        expect(page.locator(AccountDeletedPage.HEADING)).to_be_visible()
        account_deleted.click_continue()
