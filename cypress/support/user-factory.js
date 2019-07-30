import { User         } from '../support/user'
import { RegisterPage } from '../pages/user/register-page'

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

    // This is a shortcut method that gets a registered, confirmed,
    // test user by using the test-mode-only endpoint. It does
    // not log them in
    getNextConfirmedUser() {
        const user = this.getNext()

        const url = '/test/create_user'
        
        cy.request({
            url: '/test/create_user',
            method: 'POST',
            qs: {
                name:     user.getName(),
                email:    user.getEmail(),
                password: user.getPassword()
            }

        })

        return user
    }
}

