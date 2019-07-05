package com.ytfc.blog.pages.user;

import com.ytfc.blog.utility.Helper;
import com.ytfc.blog.forms.ForgotNameForm;
import com.ytfc.blog.pages.PageObject;

import org.openqa.selenium.WebDriver;

public class ForgotNamePage extends PageObject {
    private ForgotNameForm form;

    public ForgotNameForm getForm() {
        return this.form;
    }

    public ForgotNamePage(WebDriver driver) {
        this.driver = driver;
        this.form   = new ForgotNameForm(driver);
    }

    public ForgotNamePage get() {
        Helper.get(driver, "user/forgot_name");

        assertPageTitle("Forgot name", "Page has correct title");
        form.assertFieldTypes("Field has correct type");

        return this; // Chainable
    }

    public void submit(String reqEmail) {
        get();
        form.getField("email").setValue(reqEmail);
        form.getButton().click();
    }

}
