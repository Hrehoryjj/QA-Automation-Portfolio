export default abstract class BasePage {
  private static readonly COOKIE_BANNER_ACCEPT_BUTTON = '#onetrust-accept-btn-handler';

  async navigateTo(url: string) {
    await browser.url(url);
    await this.dismissCookieBannerIfPresent();
  }

  protected async safeScrollIntoView(element: any) {
    await browser.execute((el) => {
      el.scrollIntoView({ block: 'center', behavior: 'instant' as ScrollBehavior });
    }, element);
    await browser.pause(300);
  }

  private async dismissCookieBannerIfPresent() {
    const acceptButton = $(BasePage.COOKIE_BANNER_ACCEPT_BUTTON);
    const bannerFound = await acceptButton
      .waitForExist({ timeout: 8000, timeoutMsg: '' })
      .catch(() => false);
    if (bannerFound) {
      await acceptButton.click();
      await browser.pause(500);
    }
  }
}