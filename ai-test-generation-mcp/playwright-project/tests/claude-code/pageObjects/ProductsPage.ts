import type { Locator } from '@playwright/test';
import { BasePage } from './BasePage';

const PRODUCTS_PATH = '/products';
const addToCartButton = (productId: number) => `.add-to-cart[data-product-id="${productId}"]`;
const CONTINUE_SHOPPING_BUTTON = 'Continue Shopping';

export class ProductsPage extends BasePage {
  async goto(): Promise<void> {
    await this.open(PRODUCTS_PATH);
  }

  private getAddToCartButton(productId: number): Locator {
    return this.page.locator(addToCartButton(productId)).first();
  }

  private getContinueShoppingButton(): Locator {
    return this.page.getByRole('button', { name: CONTINUE_SHOPPING_BUTTON });
  }

  async addProductToCart(productId: number): Promise<void> {
    await this.getAddToCartButton(productId).click();
    await this.getContinueShoppingButton().click();
  }
}
