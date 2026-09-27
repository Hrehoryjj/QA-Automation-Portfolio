import { test, expect } from '../fixtures/test';
import { ProductsPage } from '../pageObjects/ProductsPage';
import { CartPage } from '../pageObjects/CartPage';

test('TC-06 Remove Products From Cart', async ({ page }) => {
  const productsPage = new ProductsPage(page);
  const cartPage = new CartPage(page);

  await productsPage.goto();
  await productsPage.addProductToCart(1);
  await productsPage.addProductToCart(2);

  await cartPage.clickCartLink();

  await expect(cartPage.getProductRow(1)).toBeVisible();
  await expect(cartPage.getProductRow(2)).toBeVisible();

  await cartPage.removeProduct(1);

  await expect(cartPage.getProductRow(1)).toHaveCount(0);
  await expect(cartPage.getProductRow(2)).toBeVisible();
});
