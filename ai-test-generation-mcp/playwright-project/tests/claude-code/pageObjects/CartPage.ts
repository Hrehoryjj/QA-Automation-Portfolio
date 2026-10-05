import type { Locator } from '@playwright/test';
import { BasePage } from './BasePage';

const productRow = (productId: number) => `#product-${productId}`;
const deleteButton = (productId: number) => `.cart_quantity_delete[data-product-id="${productId}"]`;

export class CartPage extends BasePage {
  getProductRow(productId: number): Locator {
    return this.page.locator(productRow(productId));
  }

  async removeProduct(productId: number): Promise<void> {
    await this.page.locator(deleteButton(productId)).click();
  }
}
