package com.ytfc.blog.forms.forgotname;

import com.ytfc.blog.forms.FormButton;

import org.openqa.selenium.WebDriver;

public class FormSubmit extends FormButton {

    public FormSubmit(WebDriver driver) {
        super(driver, "send-me-my-login-name-button");
    }

    
}
