import { RowBase     } from './row-base'
import { TableColumn } from './table-column'

export class ListLinksRow extends RowBase {
    constructor(tableId, rowIndex) {
        super(tableId, rowIndex);
        this._columns.id               = new TableColumn(1)
        this._columns.embed_identifier = new TableColumn(2)
        this._columns.list_priority    = new TableColumn(3)
        this._columns.description      = new TableColumn(4)
        this._columns.edit             = new TableColumn(5)
        this._columns.delete           = new TableColumn(6)
        this._columns.copy             = new TableColumn(7)
    }


    assertPriority(n) {
        this.assertText('list_priority', n.toString())

        return this // Chainable
    }

    assertIdentifier(identifier) {
        this.assertText('embed_identifier', identifier)

        return this // Chainable
    }

    assertDescription(description) {
        this.assertText('description', description)

        return this // Chainable
    }
}
