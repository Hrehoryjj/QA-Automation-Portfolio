import allure
from playwright.sync_api import expect

from pages.product_detail_page import ProductDetailPage
from pages.products_page import ProductsPage


@allure.feature("Products")
@allure.title("Browse all products and open a product detail page")
def test_all_products_and_detail(products_page: ProductsPage):
    page = products_page.page
    detail_page = ProductDetailPage(page)

    with allure.step("The products list is shown"):
        products_page.open()
        expect(page.locator(ProductsPage.ALL_PRODUCTS_HEADING)).to_be_visible()
        expect(products_page.cards()).not_to_have_count(0)

    products_page.open_product(0)

    with allure.step("The product detail page shows its core information"):
        expect(page.locator(ProductDetailPage.NAME)).to_be_visible()
        expect(page.locator(ProductDetailPage.PRICE)).to_be_visible()
        expect(page.locator(ProductDetailPage.AVAILABILITY)).to_be_visible()
        expect(page.locator(ProductDetailPage.CONDITION)).to_be_visible()
        expect(page.locator(ProductDetailPage.BRAND)).to_be_visible()
