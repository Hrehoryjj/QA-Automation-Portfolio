import allure

from pages.base_page import BasePage
from utils.allure_helpers import attach_screenshot
from utils.data_generator import UserData


class SignupPage(BasePage):
    URL_PATH = "/signup"

    ACCOUNT_INFO_HEADING = "h2.title:has-text('Enter Account Information')"
    TITLE_MR = "#id_gender1"
    TITLE_MRS = "#id_gender2"
    PASSWORD = "input[data-qa='password']"
    DAY = "select[data-qa='days']"
    MONTH = "select[data-qa='months']"
    YEAR = "select[data-qa='years']"
    NEWSLETTER = "#newsletter"
    SPECIAL_OFFERS = "#optin"
    FIRST_NAME = "input[data-qa='first_name']"
    LAST_NAME = "input[data-qa='last_name']"
    COMPANY = "input[data-qa='company']"
    ADDRESS = "input[data-qa='address']"
    ADDRESS2 = "input[data-qa='address2']"
    COUNTRY = "select[data-qa='country']"
    STATE = "input[data-qa='state']"
    CITY = "input[data-qa='city']"
    ZIPCODE = "input[data-qa='zipcode']"
    MOBILE_NUMBER = "input[data-qa='mobile_number']"
    CREATE_ACCOUNT_BUTTON = "button[data-qa='create-account']"

    def fill_account_info(self, user: UserData) -> None:
        with allure.step(f"Fill account information for {user.name}"):
            self.page.check(self.TITLE_MRS if user.title == "Mrs" else self.TITLE_MR)
            self.page.fill(self.PASSWORD, user.password)
            self.page.select_option(self.DAY, user.dob_day)
            self.page.select_option(self.MONTH, user.dob_month)
            self.page.select_option(self.YEAR, user.dob_year)
            self.page.check(self.NEWSLETTER)
            self.page.check(self.SPECIAL_OFFERS)
            self.page.fill(self.FIRST_NAME, user.first_name)
            self.page.fill(self.LAST_NAME, user.last_name)
            self.page.fill(self.COMPANY, user.company)
            self.page.fill(self.ADDRESS, user.address)
            self.page.fill(self.ADDRESS2, user.address2)
            self.page.select_option(self.COUNTRY, user.country)
            self.page.fill(self.STATE, user.state)
            self.page.fill(self.CITY, user.city)
            self.page.fill(self.ZIPCODE, user.zipcode)
            self.page.fill(self.MOBILE_NUMBER, user.mobile_number)
            attach_screenshot(self.page, "Account information filled")

    def create_account(self) -> None:
        with allure.step("Submit the account-information form"):
            self.page.click(self.CREATE_ACCOUNT_BUTTON)
