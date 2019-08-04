export class TableBase {
    constructor(id) {
        this._id = id
    }

    assertEmpty(text) {
        const sel = `div#${this.getId()}.is-empty-table > p`
        cy.get(sel).contains(text)

        return this // Chainable
    }

    assertNonEmpty() {
        const sel = `div#${this.getId()}.non-empty-table`
        cy.get(sel)

        return this // Chainable
    }

    assertRowCount(c) {
        const sel = `div#${this.getId()} tbody`
        cy.get(sel).find('tr').its('length').should('eq', c)

        return this // Chainable
    }

    getId() {
        return this._id
    }

}
