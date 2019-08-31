import { Page } from '../support/page'

import randomize from 'randomatic';

export class PageFactory {
    constructor(baseName) {
        const r = randomize('a0', 5)
        this._name = `${baseName}_${r}_`
        this._index = 1
    }

    getNext() {
        const i = this._index++
        return new Page(this._name + i.toString())
    }

    // This is a shortcut method that gets a test song into
    // the database
    getNextPage(author, name) {
        const page = this.getNext()
        page.prefixName(name)

        const url = '/test/create_page'
        
        cy.request({
            url,
            method: 'POST',
            qs: {
                username:  author.getName(),
                name:      page.getName(),
                title:     page.getTitle(),
                markdown:  page.getMarkdown()
            }

        })

        return page
    }

}

