/// <reference types="Cypress" />

import { ListSongsPage } from '../pages/song/list-songs-page'
import { UserFactory   } from '../support/user-factory'
import { SongFactory   } from '../support/song-factory'
import { EditTagsPage  } from '../pages/tag/edit-tags-page'

const label = 'edittags'
const userFactory = new UserFactory(label)
const songFactory = new SongFactory(label)

function createSongEditTags(reset) {
    if ( reset ) {
        cy.resetDatabase()
    }

    const user = userFactory.getNextSignedInUser(true)
    const song1 = songFactory.getNextSong(user)

    new ListSongsPage()
        .visit()
        .getRow(1)
        .click('tags')

    return song1
}

context('Edit Song Tags test', () => {
    describe('Form validation', () => {
        it('Edit song tags page has right title', () => {
            const song1 = createSongEditTags(true)
            
            new EditTagsPage()
                .assertTitle(`Edit tags for ${song1.getTitle()}`)
                .assertTagCount(0, 'song')
        })

        it('Form shows right errors with empty input', () => {
            createSongEditTags(true)
            
            new EditTagsPage()
                .createTag({ name: '' })
                .assertFormError('name', 'Required')
                .assertTagCount(0, 'song')
        })
    })

    describe('Tag editing', () => {
        it('new song starts with no tags, and can create new tags', () => {
            createSongEditTags(true)

            new EditTagsPage()
                .createTag({ name: 'abc1' })
                .assertTagCount(1, 'song')
                .createTag({ name: 'def ghI' }) // Spaces ok
                .assertTagCount(2, 'song')
                .createTag({ name: 'ελληνικά' }) // Unicode ok
                .assertTagCount(3, 'song')
                .assertTagName(1, 'song', 'abc1')
                .assertTagName(2, 'song', 'def ghI')
                .assertTagName(3, 'song', 'ελληνικά')
        })

        it('dupe tags only created once', () => {
            createSongEditTags(true)

            new EditTagsPage()
                .createTag({ name: 'abc1' })
                .assertTagCount(1, 'song')
                .createTag({ name: 'abc1' })
                .assertTagCount(1, 'song')
                .assertTagName(1, 'song', 'abc1')
        })

        it('tags can be deleted, and re-added', () => {
            createSongEditTags(true)

            // Add a tag, delete it, re-add it.
            new EditTagsPage()
                .createTag({ name: 'abc1' })
                .assertTagCount(1, 'song')
                .assertTagName(1, 'song', 'abc1')

                .clickTag(1, 'song')
                .assertTagCount(0, 'song')

                .createTag({ name: 'abc1' })
                .assertTagCount(1, 'song')
                .assertTagName(1, 'song', 'abc1')
        })

        it('tags can be deleted from the start of the list', () => {
            createSongEditTags(true)

            // Add three tags, delete first
            createThreeTags(1)

                .clickTag(1, 'song')
                .assertTagCount(2, 'song')

                .assertTagName(1, 'song', 'tag2')
                .assertTagName(2, 'song', 'tag3')
        })

        it('tags can be deleted from the middle of the list', () => {
            createSongEditTags(true)

            // Add three tags, delete middle one
            createThreeTags(1)

                .clickTag(2, 'song')
                .assertTagCount(2, 'song')

                .assertTagName(1, 'song', 'tag1')
                .assertTagName(2, 'song', 'tag3')
        })

        it('tags can be deleted from the end of the list', () => {
            createSongEditTags(true)
    
            // Add three tags, delete last
            createThreeTags(1)
    
                .clickTag(3, 'song')
                .assertTagCount(2, 'song')
    
                .assertTagName(1, 'song', 'tag1')
                .assertTagName(2, 'song', 'tag2')
        })

        it('tags from other songs can be copied', () => {
            const song1 = createSongEditTags(true)
            createThreeTags(1)

            const song2 = createSongEditTags(false)
            createThreeTags(4)

            // song1 has tag1, tag2, tag3
            // song2 has tag4, tag5, tag6

            // Edit song2 and copy a tag from song1
            const editPage = new EditTagsPage()
                .assertTagCount(3, 'song')  // Three song tags
                .assertTagCount(6, 'other') // Six other tags
                .assertTagName(1, 'other', 'tag1 (1)')
                .assertTagName(2, 'other', 'tag2 (1)')
                .assertTagName(3, 'other', 'tag3 (1)')
                .assertTagName(4, 'other', 'tag4 (1)')
                .assertTagName(5, 'other', 'tag5 (1)')
                .assertTagName(6, 'other', 'tag6 (1)')

                // Click tag2
                .clickTag(2, 'other')
                .assertFormValue('name', 'tag2')

            // Submit form, then Song2 now has four tags
            editPage
                .getForm().enter({})

            editPage
                .assertTagCount(4, 'song')
                .assertTagName(1, 'song', 'tag2')
                .assertTagName(2, 'song', 'tag4')
                .assertTagName(3, 'song', 'tag5')
                .assertTagName(4, 'song', 'tag6')

                // Other tags unchanged, except song count for tag 2
                .assertTagCount(6, 'other')
                .assertTagName(1, 'other', 'tag1 (1)')
                .assertTagName(2, 'other', 'tag2 (2)')
                .assertTagName(3, 'other', 'tag3 (1)')
                .assertTagName(4, 'other', 'tag4 (1)')
                .assertTagName(5, 'other', 'tag5 (1)')
                .assertTagName(6, 'other', 'tag6 (1)')
        })
    })

})

function createThreeTags(n) {
    return new EditTagsPage()
        .createTag({ name: `tag${n}` })
        .createTag({ name: `tag${n+1}` })
        .createTag({ name: `tag${n+2}` })
        .assertTagCount(3, 'song')
}
