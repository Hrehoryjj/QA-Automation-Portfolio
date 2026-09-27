import { faker } from '@faker-js/faker';

export const randomData = {
  fullName: () => faker.person.fullName(),
  email: () => faker.internet.email(),
  companyName: () => faker.company.name(),
};
