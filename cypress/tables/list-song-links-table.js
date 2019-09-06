import { TableBase        } from '../tables/table-base'
import { ListSongLinksRow } from '../tables/list-song-links-row'

export class ListSongLinksTable extends TableBase {
    constructor() {
        super('table-song-link-list')
    }

    // rowIndex starts at 1
    getRow(rowIndex) {
        return new ListSongLinksRow(this.getId(), rowIndex)
    }
    
}
