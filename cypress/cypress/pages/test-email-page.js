import { Common } from '../pages/common'

export class TestEmailPage extends Common {
    visit(type, username) {
        // TODO global config for base test URL
        cy.visit(`/test/view_email/${type}/${username}`)
        return this;
    }

    confirmRegistration() {
        cy.get('td#email-urls-good-confirm > a').click();
        return this
    }

    declineRegistration() {
        cy.get('td#email-urls-good-decline > a').click();
        return this
    }

    badConfirmRegistration(reason) {
        cy.get(`td#email-urls-bad-confirm-${reason} > a`).click();
        return this
    }

    badDeclineRegistration(reason) {
        cy.get(`td#email-urls-bad-decline-${reason} > a`).click();
        return this
    }

}
