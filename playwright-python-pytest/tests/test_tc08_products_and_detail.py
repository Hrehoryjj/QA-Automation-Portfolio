import allure
from playwright.sync_api import expect

from pages.product_detail_page import ProductDetailPage
from pages.products_page import ProductsPage


@allure.feature("Products")
@allure.title("Browse all products and open a product detail page")
def test_all_products_and_detail(products_page: ProductsPage):
    detail_page = ProductDetailPage(products_page.page)

    with allure.step("The products list is shown"):
        products_page.open()
        expect(products_page.all_products_heading()).to_be_visible()
        expect(products_page.cards()).not_to_have_count(0)
        first_product = products_page.product_summary(0)

    products_page.open_product(0)

    with allure.step("The product detail page shows the opened product and its core information"):
        expect(detail_page.name()).to_have_text(first_product["name"])
        for field in detail_page.info_fields():
            expect(field).not_to_be_empty()
