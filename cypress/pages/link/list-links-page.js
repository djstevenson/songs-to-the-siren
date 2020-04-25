import { Admin          } from '../admin'
import { ListLinksTable } from '../../tables/list-links-table'
import { CreateLinkPage } from './create-link-page'
import { DeleteLinkPage } from './delete-link-page'
import { EditLinkPage   } from './edit-link-page'

export class ListLinksPage extends Admin {
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
        return new CreateLinkPage()
    }

    createLink(args) {
        const createPage = this.clickNew()

        createPage.createLink(args)

        return this
    }

    // Shortcut to hit the edit link in the 'n'th row
    // Returns the edit form for the object
    // in the selected row
    edit(rowIndex) {
        this.getRow(rowIndex).click('edit')
        return new EditLinkPage()
    }

    // Shortcut to hit the delete link in the 'n'th row
    // Returns the delete confirmation form for the object
    // in the selected row
    delete(rowIndex) {
        this.getRow(rowIndex).click('delete')
        return new DeleteLinkPage()
    }

    // Shortcut to hit the copy link in the 'n'th row
    // Returns the Edit Link Page that copy redirects to
    copyLink(rowIndex) {
        this.getRow(rowIndex).click('copy')
        return new EditLinkPage()
    }


}
