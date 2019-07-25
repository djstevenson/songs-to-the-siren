import { Common } from '../pages/common'

export class TestUserPage extends Common {
    visit(username) {
        // TODO global config for base test URL
        cy.visit(`http://localhost:3000/test/view_user/${username}`)
        return this;
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

}
