export class RowBase {
    constructor(tableId, rowIndex) {
        this._tableId  = tableId
        this._rowIndex = rowIndex
        this._columns  = {}
    }

    getTableId() {
        return this._tableId
    }

    getRowIndex(colName) {
        return this._rowIndex
    }

    getColumnIndex(colName) {
        return this._columns[colName].getIndex()
    }

    findCell(colName) {
        const colIndex = this.getColumnIndex(colName)

        const sel = `div#${this.getTableId()}`
            + ' > table > tbody'
            + ' > tr:nth-child(' + this.getRowIndex() + ')'
            + ' > td:nth-child(' + colIndex + ')'
        return cy.get(sel)
    }

    assertText(colName, text) {
        this
            .findCell(colName)
            .contains(text)

        return this // Chainable
    }

    assertNoText(colName) {
        this
            .findCell(colName)
            .should('be.empty')
        
        return this // Chainable
    }

    click(colName) {
        this
            .findCell(colName)
            .click()
        
        return this // Chainable
    }
}
