const DragDropPage = require('../pages/dragDrop.page');

describe('TC-04: Drag and Drop', () => {
  it('should complete all drag and drop pairs and show congratulations message', async () => {
    await DragDropPage.openDragScreen();
    await DragDropPage.completeAllDragAndDrops();

    const congratsVisible = await DragDropPage.isCongratsDisplayed();
    expect(congratsVisible).toBe(true);

    const message = await DragDropPage.getCongratsMessage();
    expect(message).toBe('You made it, click retry if you want to try it again.');
  });
});