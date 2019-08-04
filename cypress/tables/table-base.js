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

    // Both row and column indices count from 1
    findRow(rowIndex) {
        const sel = this.getSelector()
            + ' > table > tbody'
            + ' > tr:nth-child(' + rowIndex + ')'
        return cy.get(sel)
    }

    findCell(rowIndex, colIndex) {
        const sel = 'td:nth-child(' + colIndex + ')'
        const row = this.findRow(rowIndex)
        return row.find(sel)
    }

    assertCell(row, col, text) {
        this
            .findCell(row, col)
            .contains(text)
        
        return this // Chainable
    }

    clickCell(row, col) {
        this
            .findCell(row, col)
            .click()
        
        return this // Chainable
    }
}
