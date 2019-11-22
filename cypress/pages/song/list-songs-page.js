import { Admin          } from '../admin'
import { ListSongsTable } from '../../tables/list-songs-table'
import { DeleteSongPage } from './delete-song-page'
import { EditSongPage   } from './edit-song-page'
import { ViewSongPage   } from './view-song-page'

export class ListSongsPage extends Admin {

    pageUrl() {
        return '/admin/song/list'
    }

    constructor() {
        super()
        this._table = new ListSongsTable()
    }

    assertEmpty() {
        this
            .getTable()
            .assertEmpty('No songs yet defined')

        return this
    }

    assertSongCount(c) {
        this
            .getTable()
            .assertRowCount(c)

        return this
    }

    // Shortcut to hit the the view page by clicking on the title
    view(rowIndex) {
        this.getRow(rowIndex).click('title')
        return new ViewSongPage()
    }

    // Shortcut to hit the edit link in the 'n'th row
    // Returns the edit page object
    edit(rowIndex) {
        this.getRow(rowIndex).click('edit')
        return new EditSongPage()
    }

    // Shortcut to hit the delete link in the 'n'th row
    // Returns the delete page object
    delete(rowIndex) {
        this.getRow(rowIndex).click('delete')
        return new DeleteSongPage()
    }

    // Shortcut to assert the title of the song in the 'n'th row
    // Returns this page object, for chaining tests
    assertSongTitle(rowIndex, expectedTitle) {
        this.getRow(rowIndex).assertText('title', expectedTitle)
        return this
    }

    // Shortcut to assert the song in the 'n'th row is unpublished
    // Returns this page object, for chaining tests
    assertSongUnpublished(rowIndex) {
        this.getRow(rowIndex).assertUnpublished()
        return this
    }

    // Shortcut to assert the song in the 'n'th row is published
    // Returns this page object, for chaining tests
    assertSongPublished(rowIndex) {
        this.getRow(rowIndex).assertPublished()
        return this
    }

    // Shortcut to publish the song in the 'n'th row
    // Returns this page object, for chaining
    publishSong(rowIndex) {
        this.assertSongUnpublished(rowIndex)
        this.getRow(rowIndex).click('publish')
        return this
    }

    // Shortcut to unpublish the song in the 'n'th row
    // Returns this page object, for chaining
    unpublishSong(rowIndex) {
        this.assertSongPublished(rowIndex)
        this.getRow(rowIndex).click('publish')
        return this
    }
}
