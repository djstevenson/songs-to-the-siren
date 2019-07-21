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

    assertNotification(expected) {
        cy
            .get('div.notification > p:first-child')
            .contains(expected);
        return this
    }

    assertFlash(expected) {
        cy
            .get('div#flash-msg')
            .contains(expected);
        return this
    }
}
