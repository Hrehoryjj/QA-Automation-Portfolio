import BasePage from './base.page';

class HomePage extends BasePage {
  private static readonly HEADER_CONTAINER = '#site-header';
  private static readonly FOOTER_CONTAINER = '#site-footer';
  private static readonly LOGO_LINK = 'a[href="/"]';
  private static readonly DROPDOWN_CONTENT = '#main-menu-content';
  private static readonly CONTACT_US_BUTTON = '=Contact us';
  private static readonly USE_CASE_BUTTONS = 'button[aria-pressed]';
  private static readonly USE_CASE_SECTION_HEADING = 'p*=SELECT USE CASE';
  private static readonly SHOP_LINK = 'a[href="https://shop.telnyx.com/"]';
  private static readonly FOOTER_COPYRIGHT_CONTAINER = 'div.flex.flex-col.gap-new-xs';
  private static readonly FOOTER_CAPTION_TEXT = '.typography-p-caption-mobile';
  private static readonly SECURITY_BADGES_TEXT = 'div.typography-p-caption-mobile*=ISO';
  private static readonly NAV_MENU_ITEM_XPATH = (itemName: string) =>
    `//*[self::button or self::a][contains(., "${itemName}")]`;
  private static readonly SUBMENU_LINK_SELECTOR = (linkText: string) => `a*=${linkText}`;
  private static readonly SOCIAL_LINK_SELECTOR = (hostFragment: string) => `a[href*="${hostFragment}"]`;
  private static readonly FOOTER_COLUMN_HEADING_SELECTOR = (columnTitle: string) => `*=${columnTitle}`;
  private static readonly LINKS_WITH_HREF = 'a[href]';

  private get headerContainer() {
    return $(HomePage.HEADER_CONTAINER);
  }

  private get footerContainer() {
    return $(HomePage.FOOTER_CONTAINER);
  }

  private get telnyxLogo() {
    return this.headerContainer.$(HomePage.LOGO_LINK);
  }

  private navMenuItem(itemName: string) {
    return this.headerContainer.$(HomePage.NAV_MENU_ITEM_XPATH(itemName));
  }

  private get dropdownContent() {
    return $(HomePage.DROPDOWN_CONTENT);
  }

  private submenuLink(linkText: string) {
    return this.dropdownContent.$(HomePage.SUBMENU_LINK_SELECTOR(linkText));
  }

  private get contactUsButton() {
    return $(HomePage.CONTACT_US_BUTTON);
  }

  private get useCaseButtons() {
    return $$(HomePage.USE_CASE_BUTTONS);
  }

  private get useCaseSectionHeading() {
    return $(HomePage.USE_CASE_SECTION_HEADING);
  }

  private get shopLink() {
    return this.footerContainer.$(HomePage.SHOP_LINK);
  }

  private get footerCopyrightText() {
    return this.footerContainer.$(HomePage.FOOTER_COPYRIGHT_CONTAINER).$$(HomePage.FOOTER_CAPTION_TEXT)[0];
  }

  private get securityBadgesText() {
    return this.footerContainer.$(HomePage.SECURITY_BADGES_TEXT);
  }

  private getSocialLink(hostFragment: string) {
    return this.footerContainer.$(HomePage.SOCIAL_LINK_SELECTOR(hostFragment));
  }

  async navigateToHome() {
    await this.navigateTo('/');
  }

  async scrollToFooter() {
    await this.footerContainer.scrollIntoView();
  }

  async isHeaderDisplayed() {
    return this.headerContainer.isDisplayed();
  }

  async getUseCaseButtonsCount() {
    await this.useCaseSectionHeading.scrollIntoView();
    await browser.pause(500);
    const buttons = await this.useCaseButtons;
    let visibleCount = 0;
    for (const button of buttons) {
      if (await button.isDisplayed()) visibleCount++;
    }
    return visibleCount;
  }

  async areAllUseCaseButtonsClickable() {
    await this.useCaseSectionHeading.scrollIntoView();
    await browser.pause(500);
    const buttons = await this.useCaseButtons;
    const visibleButtons = [];
    for (const button of buttons) {
      if (await button.isDisplayed()) visibleButtons.push(button);
    }
    if (visibleButtons.length === 0) return false;
    for (const button of visibleButtons) {
      await button.scrollIntoView();
      const clickable = await button.isClickable();
      if (!clickable) return false;
    }
    return true;
  }

  async getSecurityBadgesText() {
    await this.securityBadgesText.scrollIntoView();
    return this.securityBadgesText.getText();
  }

  async clickLogo() {
    await this.telnyxLogo.click();
  }

  async areAllTopLevelNavItemsDisplayed() {
    const items = ['Products', 'Solutions', 'Pricing', 'Why Telnyx', 'Resources', 'Developers'];
    for (const item of items) {
      const displayed = await this.navMenuItem(item).isDisplayed();
      if (!displayed) return false;
    }
    return true;
  }

  async openSolutionsDropdown() {
    await this.navMenuItem('Solutions').click();
    await this.dropdownContent.waitForDisplayed();
  }

  async openProductsDropdown() {
    await this.navMenuItem('Products').click();
    await this.dropdownContent.waitForDisplayed();
  }

  async openWhyTelnyxDropdown() {
    await this.navMenuItem('Why Telnyx').click();
    await this.dropdownContent.waitForDisplayed();
  }

  async openDevelopersDropdown() {
    await this.navMenuItem('Developers').click();
    await this.dropdownContent.waitForDisplayed();
  }

  async isDropdownDisplayed() {
    return this.dropdownContent.isDisplayed();
  }

  async clickViewAllPrimitivesLink() {
    const links = await $$(HomePage.SUBMENU_LINK_SELECTOR('View all primitives'));
    for (const link of links) {
      if (await link.isDisplayed()) {
        await link.click();
        return;
      }
    }
  }

  async isDevDocsLinkDisplayed() {
    return this.submenuLink('Dev Docs').isDisplayed();
  }

  async isDevDocsLinkClickable() {
    return this.submenuLink('Dev Docs').isClickable();
  }

  async clickContactUsButton() {
    await this.contactUsButton.isDisplayed();
    await this.contactUsButton.click();
  }


  async getFooterColumnLinks(columnTitle: string): Promise<string[]> {
    const column = this.footerContainer.$(HomePage.FOOTER_COLUMN_HEADING_SELECTOR(columnTitle)).$('..');
    const links = await column.$$(HomePage.LINKS_WITH_HREF);
    const hrefs: string[] = [];
    for (const link of links) {
      const href = await link.getAttribute('href');
      if (href) hrefs.push(href.startsWith('http') ? href : `https://telnyx.com${href}`);
    }
    return [...new Set(hrefs)];
  }

  async getSocialLinkTarget(hostFragment: string) {
    return this.getSocialLink(hostFragment).getAttribute('target');
  }

  async getShopLinkHref() {
    return this.shopLink.getAttribute('href');
  }

  async getShopLinkTarget() {
    return this.shopLink.getAttribute('target');
  }

  async getFooterCopyrightText() {
    await this.footerContainer.scrollIntoView();
    return this.footerCopyrightText.getText();
  }
}

export default new HomePage();