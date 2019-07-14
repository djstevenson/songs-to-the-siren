package com.ytfc.blog.pages.user;

import com.ytfc.blog.utility.Helper;
import com.ytfc.blog.forms.RegisterForm;
import com.ytfc.blog.pages.PageObject;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class RegisterPage extends PageObject {
    private RegisterForm form;

    public RegisterForm getForm() {
        return this.form;
    }

    public RegisterPage(WebDriver driver) {
        this.driver = driver;
        this.form   = new RegisterForm(driver);
    }

    @FindBy(id="user-register-button") WebElement registerButton;

    public RegisterPage get() {
        Helper.get(driver, "user/register");

        assertPageTitle("Register", "Page has correct title");

        // TODO Some forms don't do this
        // TODO This doesn't handle textarea
        form.assertFieldTypes("Field has correct type");

        return this; // Chainable
    }

    public RegisterPage register(String reqName, String reqEmail, String reqPassword) {
        get();
        form.getField("name").setValue(reqName);
        form.getField("email").setValue(reqEmail);
        form.getField("password").setValue(reqPassword);
        registerButton.click();

        return this; // Chainable
    }

    public RegisterPage registerQuick(String reqName) {
        register(reqName, reqName + "@example.com", "PW reg1");

        return this; // Chainable
    }
}
