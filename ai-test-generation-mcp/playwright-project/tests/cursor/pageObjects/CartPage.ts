import type { Locator } from '@playwright/test';
import { BasePage } from './BasePage';

const CART_PATH = '/view_cart';
const HEADER_CART_LINK = '#header a[href="/view_cart"]';
const productRow = (productId: number) => `#product-${productId}`;
const deleteButton = (productId: number) => `.cart_quantity_delete[data-product-id="${productId}"]`;

export class CartPage extends BasePage {
  async goto(): Promise<void> {
    await this.open(CART_PATH);
  }

  async clickCartLink(): Promise<void> {
    await this.page.locator(HEADER_CART_LINK).click();
  }

  getProductRow(productId: number): Locator {
    return this.page.locator(productRow(productId));
  }

  async removeProduct(productId: number): Promise<void> {
    await this.page.locator(deleteButton(productId)).click();
  }
}
