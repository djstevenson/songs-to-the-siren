import { User } from '../support/user'
import { RegisterPage } from '../pages/register-page'

var randomize = require('randomatic');

export class UserFactory {
    constructor(baseName) {
        this._name = baseName + '_' + randomize('a0', 5) + '_'
        this._index = 1
    }

    getNext() {
        const i = this._index++
        return new User(this._name + i.toString())
    }

    getNextRegistered() {
        const user = this.getNext()
        const page = new RegisterPage()
            .visit()
            .register(user.getName(), user.getEmail(), user.getPassword())
        return {user, page}
    }

    getNextRegisteredUser() {
        return this.getNextRegistered()['user']
    }

}

