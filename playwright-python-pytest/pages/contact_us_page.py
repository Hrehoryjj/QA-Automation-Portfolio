import allure

from pages.base_page import BasePage
from utils.allure_helpers import attach_screenshot


class ContactUsPage(BasePage):
    URL_PATH = "/contact_us"

    GET_IN_TOUCH_HEADING = "div.contact-form h2"
    NAME_INPUT = "input[data-qa='name']"
    EMAIL_INPUT = "input[data-qa='email']"
    SUBJECT_INPUT = "input[data-qa='subject']"
    MESSAGE_INPUT = "textarea[data-qa='message']"
    FILE_INPUT = "input[name='upload_file']"
    SUBMIT_BUTTON = "input[data-qa='submit-button']"
    SUCCESS_MESSAGE = "div.status.alert-success"

    def fill_form(self, name: str, email: str, subject: str, message: str) -> None:
        with allure.step(f"Fill Contact Us form as {name} <{email}>"):
            self.page.fill(self.NAME_INPUT, name)
            self.page.fill(self.EMAIL_INPUT, email)
            self.page.fill(self.SUBJECT_INPUT, subject)
            self.page.fill(self.MESSAGE_INPUT, message)
            attach_screenshot(self.page, "Contact Us form filled")

    def upload_file(self, file_path: str) -> None:
        with allure.step("Attach a file to the Contact Us form"):
            self.page.set_input_files(self.FILE_INPUT, file_path)

    def submit(self) -> None:
        with allure.step("Submit the Contact Us form"):
            self.page.click(self.SUBMIT_BUTTON)
