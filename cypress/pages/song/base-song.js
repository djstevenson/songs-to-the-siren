import { Admin         } from '../admin'
import { ListSongsPage } from './list-songs-page'

// Base class for country-editing admin-only pages
export class BaseSong extends Admin {

    // All the 'crud' pages have a cancel button
    // that returns to the list page.
    cancel() {
        this.getForm().getButton('cancel').click()
    
        return new ListSongsPage()
    }
}
