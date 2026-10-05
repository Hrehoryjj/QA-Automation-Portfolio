import os
import re

import allure
import pytest
from dotenv import load_dotenv
from playwright.sync_api import Page

from pages.cart_page import CartPage
from pages.home_page import HomePage
from pages.login_page import LoginPage
from pages.products_page import ProductsPage
from utils.data_generator import DataGenerator, UserData

load_dotenv()

SITE_URL = "https://www.automationexercise.com"


@pytest.fixture(scope="session")
def base_url() -> str:
    return SITE_URL


@pytest.fixture
def browser_context_args(browser_context_args, base_url):
    return {**browser_context_args, "base_url": base_url, "viewport": {"width": 1440, "height": 900}}


@pytest.fixture(autouse=True)
def block_consent(page: Page):
    page.route(re.compile(r"fundingchoicesmessages\.google\.com"), lambda route: route.abort())


@pytest.fixture
def data() -> DataGenerator:
    return DataGenerator()


@pytest.fixture
def new_user(page: Page, data: DataGenerator):
    user: UserData = data.new_user()
    yield user
    with allure.step(f"Teardown: make sure the account {user.email} is deleted"):
        page.request.delete(
            f"{SITE_URL}/api/deleteAccount",
            form={"email": user.email, "password": user.password},
        )


@pytest.fixture
def home_page(page: Page) -> HomePage:
    return HomePage(page)


@pytest.fixture
def login_page(page: Page) -> LoginPage:
    return LoginPage(page)


@pytest.fixture
def products_page(page: Page) -> ProductsPage:
    return ProductsPage(page)


@pytest.fixture
def cart_page(page: Page) -> CartPage:
    return CartPage(page)


@pytest.fixture
def existing_user() -> tuple[str, str]:
    email = os.environ.get("TEST_USER_EMAIL")
    password = os.environ.get("TEST_USER_PASSWORD")
    if not email or not password:
        pytest.skip("TEST_USER_EMAIL / TEST_USER_PASSWORD are not set")
    return email, password


@pytest.fixture
def logged_in_page(page: Page, existing_user: tuple[str, str]) -> HomePage:
    email, password = existing_user
    login = LoginPage(page)
    login.open()
    login.login(email, password)
    return HomePage(page)


@pytest.hookimpl(hookwrapper=True)
def pytest_runtest_makereport(item, call):
    outcome = yield
    report = outcome.get_result()
    if report.when == "call":
        page: Page | None = item.funcargs.get("page")
        if page is not None and not page.is_closed():
            allure.attach(
                page.screenshot(full_page=True),
                name="final-state",
                attachment_type=allure.attachment_type.PNG,
            )
