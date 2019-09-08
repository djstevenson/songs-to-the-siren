import { TableBase    } from './table-base'
import { ListSongsRow } from './list-songs-row'

export class ListSongsTable extends TableBase {
    constructor() {
        super('table-song-list')
    }

    // rowIndex starts at 1
    // With generics (see TypeScript), this could be 
    // in a base class. The table class would be 
    // generic over the row type.
    getRow(rowIndex) {
        return new ListSongsRow(this.getId(), rowIndex)
    }
    
}
