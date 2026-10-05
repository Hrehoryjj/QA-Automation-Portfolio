from playwright.sync_api import Locator

from pages.base_page import BasePage

SLIDER_HEADING = "h2:has-text('Full-Fledged practice website for Automation Engineers')"


class HomePage(BasePage):
    URL_PATH = "/"

    def slider_heading(self) -> Locator:
        return self.page.locator(SLIDER_HEADING)
