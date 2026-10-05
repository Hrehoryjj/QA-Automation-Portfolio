import allure
from playwright.sync_api import expect

from pages.product_detail_page import ProductDetailPage
from pages.products_page import ProductsPage


@allure.feature("Products")
@allure.title("Add a review on a product")
def test_add_review_on_product(products_page: ProductsPage, data):
    detail_page = ProductDetailPage(products_page.page)
    user = data.new_user()

    with allure.step("Open a product detail page"):
        products_page.open()
        products_page.open_product(0)
        expect(detail_page.name()).to_be_visible()

    detail_page.add_review(user.name, user.email, data.review_text())

    with allure.step("The review is accepted"):
        expect(detail_page.review_success()).to_have_text("Thank you for your review.")
