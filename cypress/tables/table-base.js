export class TableBase {
    constructor(id) {
        this._id       = id
        this._selector = 'div#' + id
        this._columns  = {}
    }

    getColumnIndex(colName) {
        return this._columns[colName].getIndex()
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

    findCell(rowIndex, colName) {
        const colIndex = this.getColumnIndex(colName)

        const sel = this.getSelector()
            + ' > table > tbody'
            + ' > tr:nth-child(' + rowIndex + ')'
            + ' > td:nth-child(' + colIndex + ')'
        return cy.get(sel)
    }

    assertCell(rowIndex, colName, text) {
        this
            .findCell(rowIndex, colName)
            .contains(text)

        return this // Chainable
    }

    assertCellEmpty(rowIndex, colName) {
        this
            .findCell(rowIndex, colName)
            .should('be.empty')
        
        return this // Chainable
    }

    clickCell(rowIndex, colName) {
        this
            .findCell(rowIndex, colName)
            .click()
        
        return this // Chainable
    }
}
