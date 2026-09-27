import { IssuesPage } from "../../pages/Issues.page";
import { test, expect } from "@playwright/test";

test.describe("Issues Page", () => {
  let issuesPage: IssuesPage;   

  test.beforeEach(async ({ page }) => {
    issuesPage = new IssuesPage(page);
    await issuesPage.navigateToIssuesPage();
  });

  test("Ensure that Filtering by Coordinator is working", async ({ page }) => {
    await issuesPage.filterByCoordinator();
    await issuesPage.selectCoordinatorByName('Defect');
    await issuesPage.applyFiltersAndOptions();
    
    const coordinatorCells = await issuesPage.coordinatorCells.allTextContents();
    expect(coordinatorCells.every(cell => cell.trim() === "Defect")).toBeTruthy();
  });

  test("Ensure that Filtering by author and adding author column is working", async ({ page }) => {
    await issuesPage.filterByAuthor();
    await issuesPage.selectAuthorByName('Go MAEDA'); 
    await issuesPage.addTableColumn('author');
    await issuesPage.applyFiltersAndOptions();

    const authorCells = await issuesPage.authorCells.allTextContents();
    expect(authorCells.every(cell => cell.includes("Go MAEDA"))).toBeTruthy();
  });
});
