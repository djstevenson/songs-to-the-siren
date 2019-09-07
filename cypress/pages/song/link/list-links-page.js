import { Admin               } from '../../admin'
import { ListLinksTable  } from '../../../tables/list-links-table'
import { CreateSongLinkPage  } from '../../../pages/song/link/create-link-page'
import { DeleteLinkPage      } from '../../pages/link/delete-link-page'

export class ListSongLinksPage extends Admin {
    pageUrl() {
        // TODO Needs song id
        return '/song/n/link/list'
    }

    constructor() {
        super()
        this._table = new ListLinksTable()
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

    clickNew() {
        cy.contains('New link').click()
        return new CreateSongLinkPage()
    }

    createLink(args) {
        const createPage = this.clickNew()

        createPage.createLink(args)

        return this
    }

    // Shortcut to hit the edit link in the 'n'th row
    // Returns the row object
    // TODO Should return the edit/delete page objects?
    edit(rowIndex) {
        return this.getRow(rowIndex).click('edit')
    }

    // Shortcut to hit the delete link in the 'n'th row
    // Returns the row object
    delete(rowIndex) {
        this.getRow(rowIndex).click('delete')
        return new DeleteLinkPage()
    }

}
