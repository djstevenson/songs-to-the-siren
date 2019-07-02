package com.ytfc.blog.pages.user;

import com.ytfc.blog.utility.Helper;
import com.ytfc.blog.forms.LoginForm;
import com.ytfc.blog.pages.PageObject;

import org.openqa.selenium.WebDriver;

public class LoginPage extends PageObject {
    private LoginForm form;

    public LoginForm getForm() {
        return this.form;
    }

    public LoginPage(WebDriver driver) {
        this.driver = driver;
        this.form = new LoginForm(driver);
    }

    public LoginPage get() {
        Helper.get(driver, "user/login");

        assertPageTitle("Login", "Page has correct title");
        form.assertFieldTypes("Field has correct type");

        return this; // Chainable
    }

    public LoginPage login(String reqName, String reqPassword) {
        get();
        form.getField("name").setValue(reqName);
        form.getField("password").setValue(reqPassword);
        form.getButton().click();

        return this; // Chainable
    }

}
