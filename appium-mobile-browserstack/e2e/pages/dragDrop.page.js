const BasePage = require('./base.page');

const SELECTORS = {
  navDragButton: '~Drag',
  congratsTitle: '//*[@text="Congratulations"]',
  congratsMessage: '//*[@text="You made it, click retry if you want to try it again."]',
};

const DRAG_PAIRS = ['l1', 'c1', 'r1', 'l2', 'c2', 'r2', 'l3', 'c3', 'r3'];

class DragDropPage extends BasePage {
  async openDragScreen() {
    await this.tap(SELECTORS.navDragButton);
  }

  async dragElementToDropZone(suffix) {
    const source = await $(`~drag-${suffix}`);
    const target = await $(`~drop-${suffix}`);
    await source.waitForDisplayed();
    await target.waitForDisplayed();
    const sourceRect = await source.getElementRect(source.elementId);
    const targetRect = await target.getElementRect(target.elementId);

    const startX = sourceRect.x + sourceRect.width / 2;
    const startY = sourceRect.y + sourceRect.height / 2;
    const endX = targetRect.x + targetRect.width / 2;
    const endY = targetRect.y + targetRect.height / 2;

    await driver.action('pointer')
      .move({ x: Math.floor(startX), y: Math.floor(startY) })
      .down()
      .move({ x: Math.floor(endX), y: Math.floor(endY), duration: 500 })
      .up()
      .perform(true);
  }

  async completeAllDragAndDrops() {
    for (const suffix of DRAG_PAIRS) {
      await this.dragElementToDropZone(suffix);
    }
  }

  async isCongratsDisplayed() {
    return this.isDisplayed(SELECTORS.congratsTitle);
  }

  async getCongratsMessage() {
    return this.getText(SELECTORS.congratsMessage);
  }
}

module.exports = new DragDropPage();
