import { Public } from '../pages/public'

export class TestEmailPage extends Public {
    constructor(type, username) {
        super();
        this._type = type
        this._name = username
    }

    getType() {
        return this._type
    }
    
    getName() {
        return this._name
    }
    
    pageUrl() {
        return '/test/view_email/' + this.getType() + '/' + this.getName()
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

    confirmReset() {
        cy.get('td#email-urls-good-reset > a').click();
        return this
    }

    badConfirmReset() {
        cy.get('td#email-urls-bad-reset-key > a').click();
        return this
    }

}
