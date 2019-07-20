export class Common {
    assertTitle(expected) {
        cy.title().should('eq', expected)
        return this
    }

    assertLoggedOut() {
        cy.get('a.login-link').contains('Login')
        return this
    }

    assertLoggedInAs(username) {
        cy.get('span.user-name').contains(username)
        return this
    }
}
