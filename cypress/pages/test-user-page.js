import { Public } from '../pages/public'

export class TestUserPage extends Public {
    constructor(username) {
        super();
        this._name = username
    }

    getName() {
        return this._name
    }
    
    pageUrl() {
        return '/test/view_user/' + this.getName()
    }

    assertIsConfirmed() {
        cy.get('#user-confirmed').contains('yes');
        return this
    }

    assertIsNotConfirmed() {
        cy.get('#user-confirmed').contains('no');
        return this
    }

    assertIsAdmin() {
        cy.get('#user-admin').contains('yes');
        return this
    }

    assertIsNotAdmin() {
        cy.get('#user-admin').contains('no');
        return this
    }

    assertNoUser() {
        this.assertVisitError(404);
    }
}
