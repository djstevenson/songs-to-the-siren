import { ViewSongPage  } from './song/view-song-page'

export class HomePageLinkSong {
    constructor(n) {
        const nth = n.toString()
        this._dom = cy.get(`ul.front-page-song-list > li:nth-child(${n})`)
    }

    assertSongTitle(expected) {
        this._dom.find('.title').contains(expected)
        return this
    }

    assertSongArtist(expected) {
        this._dom.find('.artist').contains(expected)
    }

    visit() {
        this._dom.find('a').click()
        return new ViewSongPage()
    }
}
