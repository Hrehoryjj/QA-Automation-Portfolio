import allure
from playwright.sync_api import Locator

from pages.base_page import BasePage
from utils.allure_helpers import attach_screenshot

GET_IN_TOUCH_HEADING = "div.contact-form h2"
NAME_INPUT = "input[data-qa='name']"
EMAIL_INPUT = "input[data-qa='email']"
SUBJECT_INPUT = "input[data-qa='subject']"
MESSAGE_INPUT = "textarea[data-qa='message']"
FILE_INPUT = "input[name='upload_file']"
SUBMIT_BUTTON = "input[data-qa='submit-button']"
SUCCESS_MESSAGE = "div.status.alert-success"


class ContactUsPage(BasePage):
    URL_PATH = "/contact_us"

    def get_in_touch_heading(self) -> Locator:
        return self.page.locator(GET_IN_TOUCH_HEADING)

    def success_message(self) -> Locator:
        return self.page.locator(SUCCESS_MESSAGE)

    def fill_form(self, name: str, email: str, subject: str, message: str) -> None:
        with allure.step(f"Fill Contact Us form as {name} <{email}>"):
            self.page.fill(NAME_INPUT, name)
            self.page.fill(EMAIL_INPUT, email)
            self.page.fill(SUBJECT_INPUT, subject)
            self.page.fill(MESSAGE_INPUT, message)
            attach_screenshot(self.page, "Contact Us form filled")

    def upload_file(self, file_path: str) -> None:
        with allure.step("Attach a file to the Contact Us form"):
            self.page.set_input_files(FILE_INPUT, file_path)

    def submit(self) -> None:
        with allure.step("Submit the Contact Us form and confirm the browser dialog"):
            self.page.once("dialog", lambda dialog: dialog.accept())
            self.page.click(SUBMIT_BUTTON)
