import { Public    } from '../pages/public'

export class HomePage extends Public {
    visit() {
        cy.visit('/')
        return this
    }

    assertSongCount(c) {
        const f = cy.get('main').find('section.song')
        if ( c == 0 ) {
            f.should('not.exist')
        }
        else {
            f.its('length').should('eq', c)
        }
    }
}
