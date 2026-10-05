import { faker } from '@faker-js/faker';

export function generateSubscriptionEmail(): string {
  return faker.internet
    .email({ provider: 'example-mail.test', allowSpecialCharacters: false })
    .toLowerCase();
}
