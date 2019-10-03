import { Page } from './page'

import randomize from 'randomatic';

export class ContentFactory {
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
    getNextContent(author, name) {
        const content = this.getNext()
        content.prefixName(name)

        const url = '/test/admin_create_content'
        
        cy.request({
            url,
            method: 'POST',
            qs: {
                username:  author.getName(),
                name:      content.getName(),
                title:     content.getTitle(),
                markdown:  content.getMarkdown()
            }

        })

        return content
    }

}

