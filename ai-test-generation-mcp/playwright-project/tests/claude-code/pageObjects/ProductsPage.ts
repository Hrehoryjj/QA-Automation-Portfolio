import type { Locator } from '@playwright/test';
import { BasePage } from './BasePage';

export class ProductsPage extends BasePage {
  async goto(): Promise<void> {
    await this.open('/products');
  }

  private getAddToCartButton(productId: number): Locator {
    return this.page.locator(`.add-to-cart[data-product-id="${productId}"]`).first();
  }

  private getContinueShoppingButton(): Locator {
    return this.page.getByRole('button', { name: 'Continue Shopping' });
  }

  async addProductToCart(productId: number): Promise<void> {
    await this.getAddToCartButton(productId).click();
    await this.getContinueShoppingButton().click();
  }
}
