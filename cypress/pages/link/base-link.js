import { Admin         } from '../admin'
import { ListLinksPage } from './list-links-page'

// Base class for link-editing admin-only pages
export class BaseLink extends Admin {


    // All the 'crud' pages have a cancel button
    // that returns to the list page.
    cancel() {
        this.getForm().getButton('cancel').click()
    
        return new ListLinksPage()
    }
}
