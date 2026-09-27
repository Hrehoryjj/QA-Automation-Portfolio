describe('TC-04 Search Product', () => {
  it('returns a non-empty result set that includes a known matching product', () => {
    cy.visit('/');

    cy.prompt([
      'click the Products link in the navigation menu',
      'type "Top" into the product search input',
      'click the search button',
      'verify the page heading text "Searched Products" is visible',
    ]);

    cy.get('.product-image-wrapper .productinfo p').should('have.length.greaterThan', 0);
    cy.contains('.product-image-wrapper .productinfo p', 'Blue Top').should('be.visible');
  });
});
