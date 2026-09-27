import random
import string
from dataclasses import dataclass
from datetime import date

from faker import Faker

fake = Faker()

_COUNTRIES = ["India", "United States", "Canada", "Australia", "Israel", "New Zealand", "Singapore"]


@dataclass
class UserData:
    title: str
    name: str
    email: str
    password: str
    dob_day: str
    dob_month: str
    dob_year: str
    first_name: str
    last_name: str
    company: str
    address: str
    address2: str
    country: str
    state: str
    city: str
    zipcode: str
    mobile_number: str


@dataclass
class PaymentData:
    name_on_card: str
    card_number: str
    cvc: str
    expiry_month: str
    expiry_year: str


class DataGenerator:
    def random_email(self) -> str:
        return f"qa.{fake.user_name()}.{random.randint(1000, 999999)}@example.com"

    def new_user(self) -> UserData:
        first_name = fake.first_name()
        last_name = fake.last_name()
        return UserData(
            title=random.choice(["Mr", "Mrs"]),
            name=f"{first_name} {last_name}",
            email=self.random_email(),
            password=fake.password(length=12),
            dob_day=str(random.randint(1, 28)),
            dob_month=str(random.randint(1, 12)),
            dob_year=str(random.randint(1970, 2005)),
            first_name=first_name,
            last_name=last_name,
            company=fake.company(),
            address=fake.street_address(),
            address2=fake.secondary_address(),
            country=random.choice(_COUNTRIES),
            state=fake.state(),
            city=fake.city(),
            zipcode=fake.postcode(),
            mobile_number=fake.numerify("##########"),
        )

    def new_payment(self) -> PaymentData:
        this_year = date.today().year
        return PaymentData(
            name_on_card=fake.name(),
            card_number="".join(random.choices(string.digits, k=16)),
            cvc="".join(random.choices(string.digits, k=3)),
            expiry_month=str(random.randint(1, 12)).zfill(2),
            expiry_year=str(random.randint(this_year + 1, this_year + 5)),
        )

    def review_text(self) -> str:
        return fake.sentence(nb_words=10)

    def contact_message(self) -> str:
        return fake.paragraph(nb_sentences=3)
