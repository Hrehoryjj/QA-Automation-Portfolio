import allure
from playwright.sync_api import Page


def attach_screenshot(page: Page, name: str, *, full_page: bool = False) -> None:
    allure.attach(
        page.screenshot(full_page=full_page),
        name=name,
        attachment_type=allure.attachment_type.PNG,
    )
