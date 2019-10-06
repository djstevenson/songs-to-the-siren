import { Country } from './country'

import randomize from 'randomatic';

export class CountryFactory {
    constructor(baseName) {
        const r = randomize('a0', 5)
        this._name = `${baseName}_${r}_`
        this._index = 1
    }

    getNext() {
        const i = this._index++
        return new Country(this._name + i.toString())
    }

    // This is a shortcut method that gets a test song into
    // the database
    getNextCountry(author, name) {
        const country = this.getNext()
        country.prefixName(name)

        const url = '/test/admin_create_country'
        
        cy.request({
            url,
            method: 'POST',
            qs: {
                username:  author.getName(),
                name:      country.getName(),
                emoji:     country.getEmoji()
            }

        })

        return country
    }

}

