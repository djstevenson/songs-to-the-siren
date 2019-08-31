export class Page {
    constructor(baseName) {
        this._name       = `name_${baseName}`
        this._title      = `Title ${baseName}`
        this._markdown   = `Markdown ${baseName}`
    }

    getName() {
        return this._name
    }

    getTitle() {
        return this._title
    }

    getMarkdown() {
        return this._markdown
    }

    prefixName(p) {
        this._name = p + this._name
    }

    asArgs() {
        return {
            name:             this.getName(),
            title:            this.getTitle(),
            markdown:         this.getMarkdown()
        }
    }
}

