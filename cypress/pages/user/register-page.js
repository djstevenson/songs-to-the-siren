import { Public       } from '../../pages/public'
import { RegisterForm } from '../../forms/register-form'
import { LoginPage    } from '../../pages/user/login-page'

export class RegisterPage extends Public {
    pageUrl() {
        return '/user/register'
    }

    constructor() {
        super()
        this._form = new RegisterForm()
    }

    visit() {
        new LoginPage().clickRegisterLink()
        return this;
    }

    register(name, email, password) {
        this.getForm().enter({name: name, email: email, password: password})

        return this
    }

}
