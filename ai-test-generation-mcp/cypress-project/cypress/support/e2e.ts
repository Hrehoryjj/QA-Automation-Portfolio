import 'cypress-mochawesome-reporter/register';

const BLOCKED_AD_HOSTS = [
  'googlesyndication.com',
  'doubleclick.net',
  'googletagservices.com',
  'adtrafficquality.google',
  'fundingchoicesmessages.google.com',
];

const BLOCKED_AD_HOSTS_PATTERN = new RegExp(BLOCKED_AD_HOSTS.map((host) => host.replace(/\./g, '\\.')).join('|'));

beforeEach(() => {
  cy.intercept(BLOCKED_AD_HOSTS_PATTERN, (req) => {
    req.destroy();
  });
});
