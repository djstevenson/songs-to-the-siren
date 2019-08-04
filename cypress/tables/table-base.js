export class TableBase {
    constructor(id) {
        this._id       = id
        this._selector = 'div#' + id
        this._columns  = {}
    }

    assertEmpty(text) {
        const sel = this.getSelector() + '.is-empty-table > p'
        cy.get(sel).contains(text)

        return this // Chainable
    }

    assertNonEmpty() {
        const sel = this.getSelector() + '.non-empty-table'
        cy.get(sel)

        return this // Chainable
    }

    assertRowCount(c) {
        const sel = this.getSelector() + ' tbody'
        cy.get(sel).find('tr').its('length').should('eq', c)

        return this // Chainable
    }

    getId() {
        return this._id
    }

    getSelector() {
        return this._selector
    }
}
