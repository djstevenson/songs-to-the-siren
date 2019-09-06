/// <reference types="Cypress" />

import { ListSongsPage } from '../../pages/song/list-songs-page'
import { UserFactory   } from '../../support/user-factory'
import { SongFactory   } from '../../support/song-factory'
import { EditTagsPage  } from '../../pages/song/tag/edit-tags-page'

const label = 'edittags'
const userFactory = new UserFactory(label)
const songFactory = new SongFactory(label)

function createSongEditTags() {
    cy.resetDatabase()

    const user = userFactory.getNextLoggedInUser(true)
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
            const song1 = createSongEditTags()
            
            new EditTagsPage()
                .assertTitle(`Edit tags for ${song1.getTitle()}`)
                .assertTagCount(0)
        })

        it('Form shows right errors with empty input', () => {
            createSongEditTags()
            
            new EditTagsPage()
                .createTag({ name: '' })
                .assertFormError('name', 'Required')
                .assertTagCount(0)
        })
    })

    describe('Tag editing', () => {
        it('new song starts with no tags, and can create new tags', () => {
            createSongEditTags()

            new EditTagsPage()
                .createTag({ name: 'abc1' })
                .assertTagCount(1)
                .createTag({ name: 'def ghI' }) // Spaces ok
                .assertTagCount(2)
                .createTag({ name: 'ελληνικά' }) // Unicode ok
                .assertTagCount(3)
                .assertTagName(1, 'abc1')
                .assertTagName(2, 'def ghI')
                .assertTagName(3, 'ελληνικά')
        })

        it('dupe tags only created once', () => {
            createSongEditTags()

            new EditTagsPage()
                .createTag({ name: 'abc1' })
                .assertTagCount(1)
                .createTag({ name: 'abc1' })
                .assertTagCount(1)
                .assertTagName(1, 'abc1')
        })

        it('tags can be deleted, and re-added', () => {
            createSongEditTags()

            // Add a tag, delete it, re-add it.
            new EditTagsPage()
                .createTag({ name: 'abc1' })
                .assertTagCount(1)
                .assertTagName(1, 'abc1')

                .deleteTag(1)
                .assertTagCount(0)

                .createTag({ name: 'abc1' })
                .assertTagCount(1)
                .assertTagName(1, 'abc1')
        })

        it('tags can be deleted from the start of the list', () => {
            createSongEditTags()

            // Add three tags, delete first
            createThreeTags()

                .deleteTag(1)
                .assertTagCount(2)

                .assertTagName(1, 'tag2')
                .assertTagName(2, 'tag3')
        })

        it('tags can be deleted from the middle of the list', () => {
            createSongEditTags()

            // Add three tags, delete middle one
            createThreeTags()

                .deleteTag(2)
                .assertTagCount(2)

                .assertTagName(1, 'tag1')
                .assertTagName(2, 'tag3')
        })
    })

    it('tags can be deleted from the end of the list', () => {
        createSongEditTags()

        // Add three tags, delete last
        createThreeTags()

            .deleteTag(3)
            .assertTagCount(2)

            .assertTagName(1, 'tag1')
            .assertTagName(2, 'tag2')
    })
})

function createThreeTags() {
    return new EditTagsPage()
        .createTag({ name: 'tag1' })
        .createTag({ name: 'tag2' })
        .createTag({ name: 'tag3' })
        .assertTagCount(3)
}
