describe('TC-03 Verify All Products and product detail page', () => {
  it('opens the detail page of the exact product that was clicked', () => {
    cy.visit('/');

    cy.prompt([
      'click the Products link in the navigation menu',
      'verify the page heading text "All Products" is visible',
      'verify a list of products is visible',
    ]);

    cy.get('.product-image-wrapper .productinfo p')
      .first()
      .invoke('text')
      .then((firstProductName) => {
        cy.wrap(firstProductName).as('firstProductName');
      });

    cy.prompt(['click the View Product link on the first product in the list']);

    cy.get('@firstProductName').then((firstProductName) => {
      cy.get('.product-information h2').should('have.text', firstProductName);
    });

    cy.prompt([
      'verify the product detail page shows the product category',
      'verify the product detail page shows the product price',
      'verify the product detail page shows the product availability',
      'verify the product detail page shows the product condition',
      'verify the product detail page shows the product brand',
    ]);
  });
});
