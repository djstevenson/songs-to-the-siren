import { TableBase   } from '../tables/table-base'
import { TableColumn } from '../tables/table-column'

export class ListSongsTable extends TableBase {
    constructor() {
        super('table-song-list')

        this._columns.id          = new TableColumn(1)
        this._columns.title       = new TableColumn(2)
        this._columns.unapproved  = new TableColumn(3)
        this._columns.publishedAt = new TableColumn(4)
        this._columns.tags        = new TableColumn(5)
        this._columns.links       = new TableColumn(6)
        this._columns.edit        = new TableColumn(7)
        this._columns.publish     = new TableColumn(8)
        this._columns.delete      = new TableColumn(9)
    }
}
