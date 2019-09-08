import { Public       } from './public'
import { HomePageSong } from './home-page-song'

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

    findSong(n) {
        return new HomePageSong(n)
    }
}
