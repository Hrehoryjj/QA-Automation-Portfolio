import { HomePage } from '../pages/home.page';

export class FooterComponents extends HomePage {
    protected getFooterColumnLinks(columnHeading: string) {
        return this.footerContainer
            .contains(new RegExp(`^${columnHeading}$`, 'i'))
            .parent()
            .find('a');
    }

    getFooterLinkHrefs(columnHeading: string): Cypress.Chainable<string[]> {
        return this.getFooterColumnLinks(columnHeading).then(($links) => {
            const hrefs: string[] = [];
            $links.each((_, el) => {
                const href = el.getAttribute('href');
                if (href) hrefs.push(href);
            });
            return hrefs;
        });
    }
}