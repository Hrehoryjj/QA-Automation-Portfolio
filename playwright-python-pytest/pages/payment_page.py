import allure

from pages.base_page import BasePage
from utils.allure_helpers import attach_screenshot
from utils.data_generator import PaymentData


class PaymentPage(BasePage):
    URL_PATH = "/payment"

    NAME_ON_CARD = "input[data-qa='name-on-card']"
    CARD_NUMBER = "input[data-qa='card-number']"
    CVC = "input[data-qa='cvc']"
    EXPIRY_MONTH = "input[data-qa='expiry-month']"
    EXPIRY_YEAR = "input[data-qa='expiry-year']"
    PAY_BUTTON = "button[data-qa='pay-button']"

    ORDER_PLACED_HEADING = "h2[data-qa='order-placed']"
    ORDER_CONFIRMATION = "p:has-text('Your order has been placed successfully')"

    def pay(self, payment: PaymentData) -> None:
        with allure.step("Fill card details and pay"):
            self.page.fill(self.NAME_ON_CARD, payment.name_on_card)
            self.page.fill(self.CARD_NUMBER, payment.card_number)
            self.page.fill(self.CVC, payment.cvc)
            self.page.fill(self.EXPIRY_MONTH, payment.expiry_month)
            self.page.fill(self.EXPIRY_YEAR, payment.expiry_year)
            attach_screenshot(self.page, "Payment form filled")
            self.page.click(self.PAY_BUTTON)
