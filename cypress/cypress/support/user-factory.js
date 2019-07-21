import { User } from '../support/user'
import { RegisterPage } from '../pages/register-page'

export class UserFactory {
    constructor(baseName) {
        this._name = baseName
        this._index = 1
    }

    getNext() {
        return new User(this._name, this._index++)
    }

    getNextRegistered() {
        const user = this.getNext()
        const page = new RegisterPage()
            .visit()
            .register(user.getName(), user.getEmail(), user.getPassword())
        return {user, page}
    }

}

