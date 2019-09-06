import { Admin              } from '../../admin'
import { ListSongLinksTable } from '../../../tables/list-song-links-table'

export class ListSongLinksPage extends Admin {
    pageUrl() {
        // TODO Needs song id
        return '/song/n/link/list'
    }

    constructor() {
        super()
        this._table = new ListSongLinksTable()
    }

    assertEmpty() {
        this
            .getTable()
            .assertEmpty('No links for this song')

        return this
    }

    assertLinkCount(c) {
        this
            .getTable()
            .assertRowCount(c)

        return this
    }

}
