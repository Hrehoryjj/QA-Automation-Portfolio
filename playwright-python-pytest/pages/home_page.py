from pages.base_page import BasePage


class HomePage(BasePage):
    URL_PATH = "/"

    SLIDER_HEADING = "h2:has-text('Full-Fledged practice website for Automation Engineers')"
