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

export function generateUser(): UserData {
  const unique = `${Date.now()}${Math.floor(Math.random() * 10_000)}`;

  return {
    title: 'Mr.',
    name: `QA Tester ${unique}`,
    email: `qa.tester.${unique}@example-mail.test`,
    password: generatePassword(),
    birthDay: '15',
    birthMonth: 'May',
    birthYear: '1995',
    newsletter: true,
    specialOffers: true,
    firstName: 'QA',
    lastName: `Tester${unique}`,
    company: 'LuxeQuality',
    address: '123 Automation Street',
    address2: 'Suite 4B',
    country: 'United States',
    state: 'California',
    city: 'San Francisco',
    zipcode: '94105',
    mobileNumber: '5551234567',
  };
}
