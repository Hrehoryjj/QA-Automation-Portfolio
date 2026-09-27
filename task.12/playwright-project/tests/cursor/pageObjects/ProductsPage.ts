import { BasePage } from './BasePage';

export class ProductsPage extends BasePage {
  async goto(): Promise<void> {
    await this.open('/products');
  }

  async addProductToCart(productId: number): Promise<void> {
    await this.page.locator(`.add-to-cart[data-product-id="${productId}"]`).first().click();
    await this.page.locator('#cartModal.show .close-modal').click();
  }
}
