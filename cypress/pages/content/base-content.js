import { Admin           } from '../admin'
import { ListContentPage } from './list-content-page'

// Base class for content-editing admin-only pages
export class BaseContent extends Admin {

    // All the 'crud' pages have a cancel button
    // that returns to the list page.
    cancel() {
        this.getForm().getButton('cancel').click()
    
        return new ListContentPage()
    }
}
