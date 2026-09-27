import allure
from playwright.sync_api import Page

from pages.components.header import Header
from utils.allure_helpers import attach_screenshot


class BasePage:
    URL_PATH = "/"

    def __init__(self, page: Page) -> None:
        self.page = page
        self.header = Header(page)

    def open(self) -> "BasePage":
        with allure.step(f"Open {self.URL_PATH}"):
            self.page.goto(self.URL_PATH)
            self.dismiss_consent()
            attach_screenshot(self.page, "Page opened")
        return self

    def dismiss_consent(self) -> None:
        self.page.evaluate("() => document.querySelector('.fc-consent-root')?.remove()")
