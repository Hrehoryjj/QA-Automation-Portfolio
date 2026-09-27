async function randomEmail() {
  const { faker } = await import('@faker-js/faker');
  return faker.internet.email();
}

async function randomPassword() {
  const { faker } = await import('@faker-js/faker');
  return faker.internet.password({ length: 10 });
}

module.exports = { randomEmail, randomPassword };