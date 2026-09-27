import { FooterComponents } from '../components/footer.components';
const footerComponents = new FooterComponents();
describe('Footer links API validation', () => {
    let columns: { company: string; legal: string; compare: string };
    before(() => {
        cy.fixture('testData').then((data) => {
            columns = data.footerColumns;
        });
    });
    beforeEach(() => {
        footerComponents.navigateTo('/');
    });
    it('TC-08: COMPANY footer links return status 200', () => {
        footerComponents.getFooterLinkHrefs(columns.company).each((href: string) => {
            cy.request(href).its('status').should('eq', 200);
        });
    });
    it('TC-09: LEGAL footer links return status 200', () => {
        footerComponents.getFooterLinkHrefs(columns.legal).each((href: string) => {
            cy.request({ url: href, failOnStatusCode: false }).then((response) => {
                const isReportAbuse = href.includes('report-abuse');
                const isLawEnforcement = href.includes('law-enforcement-request');
                const isTrustCenter = href.includes('trust.telnyx.com');
                if (isReportAbuse || isLawEnforcement || isTrustCenter) {
                    expect([200, 403]).to.include(response.status);
                } else {
                    expect(response.status).to.eq(200);
                }
            });
        });
    });
    it('TC-10: COMPARE footer links return status 200', () => {
        footerComponents.getFooterLinkHrefs(columns.compare).each((href: string) => {
            cy.request(href).its('status').should('eq', 200);
        });
    });
});