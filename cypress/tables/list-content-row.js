import { RowBase     } from './row-base'
import { TableColumn } from './table-column'

export class ListContentRow extends RowBase {
    constructor(tableId, rowIndex) {
        super(tableId, rowIndex);
        this._columns.name      = new TableColumn(1)
        this._columns.title     = new TableColumn(2)
        this._columns.updatedAt = new TableColumn(3)
        this._columns.edit      = new TableColumn(4)
        this._columns.delete    = new TableColumn(5)
    }
}
