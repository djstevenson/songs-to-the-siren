import { Public           } from './public'
import { HomePageSong     } from './home-page-song'
import { HomePageLinkSong } from './home-page-link-song'

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

        return this
    }

    assertSongLinkCount(c) {
        const f = cy.get('ul.front-page-song-list > li')
        if ( c == 0 ) {
            f.should('not.exist')
        }
        else {
            f.its('length').should('eq', c)
        }

        return this
    }

    findSong(n) {
        return new HomePageSong(n)
    }

    findLinkSong(n) {
        return new HomePageLinkSong(n)
    }
}
