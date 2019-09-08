import { User         } from './user'
import { RegisterPage } from '../pages/user/register-page'

import randomize from 'randomatic';

export class UserFactory {
    constructor(baseName) {
        const r = randomize('a0', 5)
        this._name = `${baseName}_${r}_`
        this._index = 1
    }

    getNext(admin = false) {
        const i = this._index++
        return new User(this._name + i.toString(), admin)
    }

    getNextRegistered(admin = false) {
        const user = this.getNext(admin)
        const page = new RegisterPage()
            .visit()
            .register(user.getName(), user.getEmail(), user.getPassword())
        return {user, page}
    }

    getNextRegisteredUser(admin = false) {
        return this.getNextRegistered(admin)['user']
    }

    // This is a shortcut method that gets a registered, confirmed,
    // test user by using the test-mode-only endpoint. It does
    // not log them in
    getNextConfirmedUser(admin = false) {
        const user = this.getNext(admin)

        const url = '/test/create_user'
        
        cy.request({
            url,
            method: 'POST',
            qs: {
                name:     user.getName(),
                email:    user.getEmail(),
                password: user.getPassword(),
                admin:    admin ? 1 : 0
            }

        })

        return user
    }

    getNextLoggedInUser(admin = false) {
        const user = this.getNextConfirmedUser(admin)
        user.login()
        return user
    }
}

