export class Country {
    constructor(baseName) {
        this._name  = `name_${baseName}`
        this._emoji = baseName
    }

    getName() {
        return this._name
    }

    getEmoji() {
        return this._emoji
    }

    prefixName(p) {
        this._name = p + this._name
    }

    asArgs() {
        return {
            name:  this.getName(),
            emoji: this.getEmoji()
        }
    }
}

