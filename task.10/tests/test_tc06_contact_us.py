from pathlib import Path

import allure
from playwright.sync_api import expect

from pages.contact_us_page import ContactUsPage

ATTACHMENT = Path(__file__).parent / "data" / "sample.txt"


@allure.feature("Contact Us")
@allure.title("Submit the Contact Us form with a file attachment")
def test_contact_us_form_with_upload(page, data):
    contact_page = ContactUsPage(page)
    page.on("dialog", lambda dialog: dialog.accept())

    with allure.step("Fill and submit the form with an attached file"):
        contact_page.open()
        contact_page.fill_form(
            name=data.new_user().name,
            email=data.random_email(),
            subject="Automated check",
            message=data.contact_message(),
        )
        contact_page.upload_file(str(ATTACHMENT))
        contact_page.submit()

    with allure.step("A success message is shown"):
        expect(page.locator(ContactUsPage.SUCCESS_MESSAGE)).to_contain_text(
            "Success! Your details have been submitted successfully."
        )
