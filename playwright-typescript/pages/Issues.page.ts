import { BasePage } from './base.page';
import { Page } from '@playwright/test';

export class IssuesPage extends BasePage {
    constructor(page: Page) {
        super(page);
    }

    async navigateToIssuesPage() {
        await this.navigate('/projects/redmine/issues');
    }

    get coordinatorCells() {
        return this.page.locator('td.tracker');
    }

    get authorCells() {
        return this.page.locator('td.author');
    }

    get filterDropdown() {
        return this.page.locator('#add_filter_select');
    }

    get coordinatorSelect() {
        return this.page.locator('#values_tracker_id_1');
    }

    get authorSelect() {
        return this.page.locator('#values_author_id_1');
    }

    get optionsToggle() {
        return this.page.locator('fieldset#options legend');
    }

    get availableColumnsSelect() {
        return this.page.locator('#available_c');
    }

    get addColumnButton() {
        return this.page.locator('input.move-right');
    }

    get applyButton() {
    return this.page.locator('a.icon-checked[onclick*="query_form"]');
    }

    async filterByCoordinator() {
        await this.filterDropdown.selectOption('tracker_id'); 
    }

    async filterByAuthor() {
        await this.filterDropdown.selectOption('author_id');
    }

    async selectAuthorByName(authorName: string) {
    await this.authorSelect.selectOption({ label: authorName });
    }

    async selectCoordinatorByName(coordinatorName: string) {
        await this.coordinatorSelect.selectOption({ label: coordinatorName });
    }

    async addTableColumn(columnValue: string) {
        await this.optionsToggle.click();
        await this.availableColumnsSelect.selectOption(columnValue);
        await this.addColumnButton.click();
    }

    async applyFiltersAndOptions() {
        await this.applyButton.click();
    }
};
