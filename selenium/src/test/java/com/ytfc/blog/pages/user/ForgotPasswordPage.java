package com.ytfc.blog.pages.user;

import com.ytfc.blog.utility.Helper;
import com.ytfc.blog.forms.ForgotPasswordForm;
import com.ytfc.blog.pages.PageObject;

import org.openqa.selenium.WebDriver;

public class ForgotPasswordPage extends PageObject {
    private ForgotPasswordForm form;

    public ForgotPasswordForm getForm() {
        return this.form;
    }

    public ForgotPasswordPage(WebDriver driver) {
        this.driver = driver;
        this.form   = new ForgotPasswordForm(driver);
    }

    public ForgotPasswordPage get() {
        Helper.get(driver, "user/forgot_password");

        assertPageTitle("Forgot password", "Page has correct title");
        form.assertFieldTypes("Field has correct type");

        return this; // Chainable
    }

    public void submit(String reqEmail) {
        get();
        form.getField("email").setValue(reqEmail);
        form.getButton().click();
    }

}
