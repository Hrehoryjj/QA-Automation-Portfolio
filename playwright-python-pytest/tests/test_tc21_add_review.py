import allure
from playwright.sync_api import expect

from pages.product_detail_page import ProductDetailPage
from pages.products_page import ProductsPage


@allure.feature("Products")
@allure.title("Add a review on a product")
def test_add_review_on_product(products_page: ProductsPage, data):
    page = products_page.page
    detail_page = ProductDetailPage(page)
    user = data.new_user()

    with allure.step("Open a product detail page"):
        products_page.open()
        products_page.open_product(0)
        expect(page.locator(ProductDetailPage.NAME)).to_be_visible()

    detail_page.add_review(user.name, user.email, data.review_text())

    with allure.step("The review is accepted"):
        expect(page.locator(ProductDetailPage.REVIEW_SUCCESS)).to_contain_text(
            "Thank you for your review."
        )
