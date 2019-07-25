var reverse = require('reverse-string')

export class User {
    constructor(baseName) {
        this._name = baseName
        this._email = this._name + "@example.com"
        this._password = "PW " + reverse(this._name)
    }

    getName() {
        return this._name
    }

    getBadName() {
        return this._name + 'a'
    }

    getEmail() {
        return this._email
    }

    getBadEmail() {
        return 'e' + this._email
    }

    getPassword() {
        return this._password
    }

    getBadPassword() {
        return this._password + 'x'
    }

}

