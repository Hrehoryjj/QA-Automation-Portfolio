import allure
from playwright.sync_api import expect

from pages.account_pages import AccountCreatedPage, AccountDeletedPage
from pages.cart_page import CartPage
from pages.checkout_page import CheckoutPage
from pages.login_page import LoginPage
from pages.payment_page import PaymentPage
from pages.products_page import ProductsPage
from utils.data_generator import UserData


@allure.feature("Checkout")
@allure.title("Place an order, registering while checking out")
def test_place_order_register_while_checkout(products_page: ProductsPage, new_user: UserData, data):
    page = products_page.page
    cart_page = CartPage(page)
    login_page = LoginPage(page)
    account_created = AccountCreatedPage(page)
    account_deleted = AccountDeletedPage(page)
    checkout_page = CheckoutPage(page)
    payment_page = PaymentPage(page)

    with allure.step("Add a product and start checkout as a guest"):
        products_page.open()
        product = products_page.product_summary(0)
        products_page.add_product_to_cart(0)
        products_page.go_to_cart_from_modal()
        cart_page.proceed_to_checkout()
        cart_page.checkout_register_or_login()

    with allure.step("Register a new account during checkout"):
        login_page.register(new_user)
        expect(account_created.heading()).to_be_visible()
        account_created.click_continue()
        expect(products_page.header.logged_in_as()).to_have_text(f"Logged in as {new_user.name}")

    with allure.step("Return to the cart and proceed to checkout"):
        products_page.header.go_to_cart()
        cart_page.proceed_to_checkout()

    with allure.step("Delivery and invoice addresses match the registered user"):
        city_line = f"{new_user.city} {new_user.state} {new_user.zipcode}"
        for address in (checkout_page.delivery_address(), checkout_page.invoice_address()):
            expect(address).to_contain_text(f"{new_user.first_name} {new_user.last_name}")
            expect(address).to_contain_text(new_user.address)
            expect(address).to_contain_text(city_line)
            expect(address).to_contain_text(new_user.country)
            expect(address).to_contain_text(new_user.mobile_number)

    with allure.step("The order review lists the added product with its price"):
        expect(checkout_page.order_items().filter(has_text=product["name"])).to_contain_text(product["price"])

    with allure.step("Place the order and pay"):
        checkout_page.add_comment(data.contact_message())
        checkout_page.place_order()
        payment_page.pay(data.new_payment())

    with allure.step("The order is confirmed"):
        expect(payment_page.order_placed_heading()).to_be_visible()
        expect(payment_page.order_confirmation()).to_be_visible()

    with allure.step("Delete the account"):
        products_page.header.delete_account()
        expect(account_deleted.heading()).to_be_visible()
        account_deleted.click_continue()
