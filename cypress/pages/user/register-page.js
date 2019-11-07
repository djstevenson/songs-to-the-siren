import { Public       } from '../public'
import { RegisterForm } from '../../forms/register-form'
import { SignInPage   } from './sign-in-page'

export class RegisterPage extends Public {
    pageUrl() {
        return '/user/register'
    }

    constructor() {
        super()
        this._form = new RegisterForm()
    }

    visit() {
        new SignInPage().clickRegisterLink()
        return this;
    }

    register(name, email, password) {
        this.getForm().enter({name, email, password})

        return this
    }

}
