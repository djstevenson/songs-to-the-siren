import { Admin } from '../../pages/admin'

export class ListSongsPage extends Admin {
    pageUrl() {
        return '/song/list'
    }

    clickNewSongLink() {
        this.visit()
        cy.contains('New song').click()
    }
}
