export class HomePageSong {
    constructor(n) {
        this._dom = cy.get('section.song:nth-child(' + n.toString() + ')')
    }

    assertSongTitle(expected) {
        this._dom.find('h2.title').contains(expected)
    }
}
