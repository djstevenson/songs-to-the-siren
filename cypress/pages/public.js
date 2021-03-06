export class Public {
    getForm() {
        return this._form
    }

    getTable() {
        return this._table
    }

    assertTitle(expected) {
        cy.title().should('eq', expected)
        return this
    }

    assertSignedOut() {
        cy.get('a.sign-in-link').contains('Sign in')
        return this
    }

    assertSignedInAs(username) {
        cy.get('span.user-name').contains(username)
        return this
    }

    clickAdminHomeLink(username) {
        cy
            .get('a.admin-home-link').click()
        return this
    }

    assertSignedInAsAdmin(username) {
        cy
            .get('span.user-name').contains(username)
            .get('a.admin-home-link').contains('Admin home')
        return this
    }

    assertNotification(title, message) {
        cy
            .get('h2.notification-title').contains(title)
            .get('div.notification > p:first-child').contains(message);
        return this
    }

    assertFlash(expected) {
        cy
            .get('div#flash-msg').contains(expected)
        return this
    }

    assertNoFormError(key) {
        this.getForm().getError(key).should('be.empty')
        return this
    }

    assertFormError(key, expected) {
        this.getForm().getError(key).contains(expected)
        return this
    }

    assertFormValue(field, expected) {
        this.getForm().assertValue(field, expected)
        return this
    }

    // rowIndex counts from 1
    assertCell(row, colName, text) {
        return this.getTable().assertCell(row, colName, text)
    }

    visit() {
        cy.visit(this.pageUrl())
        return this
    }

    assertVisitError(err) {
        cy
            .request({
                url:              this.pageUrl(),
                failOnStatusCode: false
            })
            .its('status')
            .should('eq', err)
    }

    // Gets table row, if there is a table, 
    // rowIndex counts from 1
    getRow(rowIndex) {
        return this.getTable().getRow(rowIndex)
    }

    
}
