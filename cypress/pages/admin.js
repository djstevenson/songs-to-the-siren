import { Public         } from './public'

// Base class for admin-only pages
export class Admin extends Public {

    // Most (all?) admin pages with forms should have a cancel button
    cancel() {
        this.getForm().getButton('cancel').click()
    
        return this
    }


}
