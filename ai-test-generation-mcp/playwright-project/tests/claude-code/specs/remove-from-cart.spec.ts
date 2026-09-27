import { test, expect } from '../fixtures/test';
import { ProductsPage } from '../pageObjects/ProductsPage';
import { CartPage } from '../pageObjects/CartPage';

test.describe('TC-06 Remove Products From Cart', () => {
  test('removing one product leaves the other in the cart', async ({ page }) => {
    const productsPage = new ProductsPage(page);
    const cartPage = new CartPage(page);

    await productsPage.goto();
    await productsPage.addProductToCart(1);
    await productsPage.addProductToCart(2);

    await productsPage.clickCartLink();

    await expect(cartPage.getProductRow(1)).toContainText('Blue Top');
    await expect(cartPage.getProductRow(2)).toContainText('Men Tshirt');

    await cartPage.removeProduct(1);

    await expect(cartPage.getProductRow(1)).toHaveCount(0);
    await expect(cartPage.getProductRow(2)).toContainText('Men Tshirt');
  });
});
