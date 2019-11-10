import { RowBase     } from './row-base'
import { TableColumn } from './table-column'

export class ListLinksRow extends RowBase {
    constructor(tableId, rowIndex) {
        super(tableId, rowIndex);
        this._columns.id          = new TableColumn(1)
        this._columns.priority    = new TableColumn(2)
        this._columns.identifier  = new TableColumn(3)
        this._columns.class       = new TableColumn(4)
        this._columns.url         = new TableColumn(5)
        this._columns.extras      = new TableColumn(6)
        this._columns.edit        = new TableColumn(7)
        this._columns.delete      = new TableColumn(8)
    }


    assertPriority(n) {
        this.assertText('priority', n.toString())

        return this // Chainable
    }

    assertIdentifier(identifier) {
        this.assertText('identifier', identifier)

        return this // Chainable
    }
}
