package com.ytfc.blog.pages.user;

import com.ytfc.blog.utility.Helper;
import com.ytfc.blog.forms.PasswordResetForm;
import com.ytfc.blog.pages.PageObject;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class PasswordResetPage extends PageObject {
    private PasswordResetForm form;

    public PasswordResetForm getForm() {
        return this.form;
    }

    public PasswordResetPage(WebDriver driver) {
        this.driver = driver;
        this.form   = new PasswordResetForm(driver);
    }

    @FindBy(id="set-new-password-button") WebElement registerButton;

    public PasswordResetPage get(int id, String key) {
        Helper.get(driver, "user/" + String.valueOf(id) + "/reset/" + key);

        assertPageTitle("Reset password", "Page has correct title");
        form.assertFieldTypes("Fields have correct type");

        return this; // Chainable
    }

    public void reset(String reqPassword) {
        form.getField("password").setValue(reqPassword);
        registerButton.click();
    }
}
