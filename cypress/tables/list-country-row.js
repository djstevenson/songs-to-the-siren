import { RowBase     } from './row-base'
import { TableColumn } from './table-column'

export class ListCountryRow extends RowBase {
    constructor(tableId, rowIndex) {
        super(tableId, rowIndex);
        this._columns.name      = new TableColumn(1)
        this._columns.emoji     = new TableColumn(2)
        this._columns.edit      = new TableColumn(3)
        this._columns.delete    = new TableColumn(4)
    }
}
