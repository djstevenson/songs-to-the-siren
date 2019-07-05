package com.ytfc.blog.forms.forgotpassword;

import com.ytfc.blog.forms.FormButton;

import org.openqa.selenium.WebDriver;

public class FormSubmit extends FormButton {

    public FormSubmit(WebDriver driver) {
        super(driver, "request-password-reset-button");
    }

    
}
