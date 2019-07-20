export class Common {
    assertTitle(expected) {
        cy.title().should('eq', expected)
        return this
    }
}
