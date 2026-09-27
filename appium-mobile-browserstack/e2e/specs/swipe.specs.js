const SwipePage = require('../pages/swipe.page');

describe('TC-02: Swipe to reveal content', () => {
  it('should swipe up until "You found me!!!" is visible', async () => {
    await SwipePage.openSwipeScreen();
    const found = await SwipePage.swipeUpUntilFound();
    expect(found).toBe(true);
  });
});

describe('TC-03: Carousel swipe', () => {
  it('should swipe carousel to next slide', async () => {
    await SwipePage.openSwipeScreen();
    await SwipePage.swipeCarouselOnce();
    const isNextSlideVisible = await SwipePage.isSecondSlideDisplayed();
    expect(isNextSlideVisible).toBe(true);
  });
});