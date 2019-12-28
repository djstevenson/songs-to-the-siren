export class HomePageSong {
    constructor(n) {
        const nth = n.toString()
        this._dom = cy.get(`section.song:nth-child(${nth})`)
    }

    assertSongTitle(expected) {
        this._dom.find('h2.title').contains(expected)
    }

    visit() {
        this._dom.find('p.more > a').click()
    }
}
