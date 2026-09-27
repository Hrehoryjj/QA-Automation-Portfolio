describe('TC-07 Login with incorrect email or password', () => {
  it('shows an error and does not log the user in', () => {
    cy.visit('/login');

    cy.prompt([
      'type "no-such-user@example-mail.test" into the Email Address field of the login form',
      'type "WrongPass1!" into the Password field of the login form',
      'click the Login button',
    ]);

    cy.get('[data-qa="login-password"]')
      .parents('form')
      .should('contain.text', 'Your email or password is incorrect!');
    cy.contains(/Logged in as/i).should('not.exist');
  });
});
