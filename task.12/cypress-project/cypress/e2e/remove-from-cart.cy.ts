describe('TC-06 Remove Products From Cart', () => {
  it('removing one product leaves the other in the cart', () => {
    cy.visit('/products');

    cy.prompt([
      'add the first product in the list to the cart',
      'dismiss the "Added!" confirmation by clicking "Continue Shopping"',
      'add the second product in the list to the cart',
      'dismiss the "Added!" confirmation by clicking "Continue Shopping"',
      'click the "Cart" link in the header navigation',
    ]);

    cy.get('#product-1').should('contain.text', 'Blue Top');
    cy.get('#product-2').should('contain.text', 'Men Tshirt');

    cy.prompt(['remove the first product from the cart by clicking its "X" button']);

    cy.get('#product-1').should('not.exist');
    cy.get('#product-2').should('contain.text', 'Men Tshirt');
  });
});
