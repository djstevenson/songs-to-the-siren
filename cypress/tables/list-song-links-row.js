import { RowBase     } from '../tables/row-base'
import { TableColumn } from '../tables/table-column'

export class ListSongLinksRow extends RowBase {
    constructor(tableId, rowIndex) {
        super(tableId, rowIndex);
        this._columns.id          = new TableColumn(1)
        this._columns.priority    = new TableColumn(2)
        this._columns.name        = new TableColumn(3)
        this._columns.url         = new TableColumn(4)
        this._columns.extras      = new TableColumn(5)
        this._columns.edit        = new TableColumn(6)
        this._columns.delete      = new TableColumn(7)
    }

}
