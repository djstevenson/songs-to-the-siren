import { TableBase    } from '../tables/table-base'
import { ListSongsRow } from '../tables/list-songs-row'

export class ListSongsTable extends TableBase {
    constructor() {
        super('table-song-list')
    }

    // rowIndex starts at 1
    getRow(rowIndex) {
        return new ListSongsRow(this.getId(), rowIndex)
    }
    
}
