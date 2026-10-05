import { BasePage } from './BasePage';

const PRODUCTS_PATH = '/products';
const addToCartButton = (productId: number) => `.add-to-cart[data-product-id="${productId}"]`;
const CART_MODAL_CLOSE_BUTTON = '#cartModal.show .close-modal';

export class ProductsPage extends BasePage {
  async goto(): Promise<void> {
    await this.open(PRODUCTS_PATH);
  }

  async addProductToCart(productId: number): Promise<void> {
    await this.page.locator(addToCartButton(productId)).first().click();
    await this.page.locator(CART_MODAL_CLOSE_BUTTON).click();
  }
}
