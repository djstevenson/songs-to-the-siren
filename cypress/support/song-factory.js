import { Song } from '../support/song'

import randomize from 'randomatic';

export class SongFactory {
    constructor(baseName) {
        const r = randomize('a0', 5)
        this._name = `${baseName}_${r}_`
        this._index = 1
    }

    // TODO Add 'published' flag?
    getNext() {
        const i = this._index++
        return new Song(this._name + i.toString())
    }

    // This is a shortcut method that gets a test song into
    // the database
    getNextSong(author, published = false) {
        const song = this.getNext()

        const url = '/test/create_song'
        
        cy.request({
            url,
            method: 'POST',
            qs: {
                username:    author.getName(),
                title:       song.getTitle(),
                artist:      song.getArtist(),
                album:       song.getAlbum(),
                image:       song.getImage(),
                country_id:  song.getCountryId(),
                released_at: song.getReleasedAt(),
                summary:     song.getSummary(),
                full:        song.getFull(),
                published:   published ? 1 : 0,
            }

        })

        return song
    }

    // TODO Is this the right class for these?
    //      These are more like 'song util' methods
    resetDatabase() {
        const url = '/test/reset'

        cy.request({
            url,
            method: 'POST',
        })
    }
}

