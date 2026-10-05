from pathlib import Path

import allure
from playwright.sync_api import expect

from pages.contact_us_page import ContactUsPage

ATTACHMENT = Path(__file__).parent / "data" / "sample.txt"


@allure.feature("Contact Us")
@allure.title("Submit the Contact Us form with a file attachment")
def test_contact_us_form_with_upload(page, data):
    contact_page = ContactUsPage(page)

    with allure.step("Fill and submit the form with an attached file"):
        contact_page.open()
        expect(contact_page.get_in_touch_heading()).to_have_text("Get In Touch")
        contact_page.fill_form(
            name=data.new_user().name,
            email=data.random_email(),
            subject="Automated check",
            message=data.contact_message(),
        )
        contact_page.upload_file(str(ATTACHMENT))
        contact_page.submit()

    with allure.step("A success message is shown"):
        expect(contact_page.success_message()).to_have_text(
            "Success! Your details have been submitted successfully."
        )
