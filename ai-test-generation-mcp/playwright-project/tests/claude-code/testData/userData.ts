import { faker } from '@faker-js/faker';

export type UserTitle = 'Mr.' | 'Mrs.';

export interface UserData {
  title: UserTitle;
  name: string;
  email: string;
  password: string;
  birthDay: string;
  birthMonth: string;
  birthYear: string;
  newsletter: boolean;
  specialOffers: boolean;
  firstName: string;
  lastName: string;
  company: string;
  address: string;
  address2: string;
  country: string;
  state: string;
  city: string;
  zipcode: string;
  mobileNumber: string;
}

const SITE_COUNTRIES = [
  'India',
  'United States',
  'Canada',
  'Australia',
  'Israel',
  'New Zealand',
  'Singapore',
];

function generatePassword(): string {
  const upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
  const lower = 'abcdefghijkmnopqrstuvwxyz';
  const digit = '23456789';
  const special = '!@#$%^&*';
  const pick = (chars: string) => chars[Math.floor(Math.random() * chars.length)];

  const required = [pick(upper), pick(digit), pick(special)];
  const pool = upper + lower + digit + special;
  const rest = Array.from({ length: 7 }, () => pick(pool));

  return [...required, ...rest].sort(() => Math.random() - 0.5).join('');
}

export function generateEmail(): string {
  return faker.internet
    .email({ provider: 'example-mail.test', allowSpecialCharacters: false })
    .replace('@', `.${Date.now()}@`)
    .toLowerCase();
}

export function generateUser(): UserData {
  const firstName = faker.person.firstName();
  const lastName = faker.person.lastName();
  const birthDate = faker.date.birthdate({ min: 18, max: 60, mode: 'age' });

  return {
    title: faker.helpers.arrayElement<UserTitle>(['Mr.', 'Mrs.']),
    name: `${firstName} ${lastName}`,
    email: generateEmail(),
    password: generatePassword(),
    birthDay: String(Math.min(birthDate.getDate(), 28)),
    birthMonth: birthDate.toLocaleString('en-US', { month: 'long' }),
    birthYear: String(birthDate.getFullYear()),
    newsletter: faker.datatype.boolean(),
    specialOffers: faker.datatype.boolean(),
    firstName,
    lastName,
    company: faker.company.name(),
    address: faker.location.streetAddress(),
    address2: faker.location.secondaryAddress(),
    country: faker.helpers.arrayElement(SITE_COUNTRIES),
    state: faker.location.state(),
    city: faker.location.city(),
    zipcode: faker.location.zipCode('#####'),
    mobileNumber: faker.string.numeric(10),
  };
}
