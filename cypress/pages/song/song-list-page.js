import { Admin } from '../../pages/admin'
import { verify } from 'crypto';

export class SongListPage extends Admin {
    pageUrl() {
        return '/song/list'
    }

    visit() {
        cy.visit(this.pageUrl())
        return this
    }

    visitAssertError(err) {
        cy
            .request({
                url:              this.pageUrl(),
                failOnStatusCode: false
            })
            .its('status')
            .should('eq', err)
    }

}
