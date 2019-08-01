import { Song } from '../support/song'

var randomize = require('randomatic');

export class SongFactory {
    constructor(baseName) {
        this._name = baseName + '_' + randomize('a0', 5) + '_'
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
        const song = this.getNext(published)

        const url = '/test/create_song'
        
        cy.request({
            url: url,
            method: 'POST',
            qs: {
                username:    author.getName(),
                title:       song.getTitle(),
                artist:      song.getArtist(),
                album:       song.getAlbum(),
                country_id:  song.getCountryId(),
                released_at: song.getReleasedAt(),
                summary:     song.getSummary(),
                full:        song.getFull(),
                published:   published ? 1 : 0,
            }

        })

        return song
    }
}

