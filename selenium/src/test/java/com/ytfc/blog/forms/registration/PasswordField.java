package com.ytfc.blog.forms.registration;

import com.ytfc.blog.forms.FormField;

import org.openqa.selenium.WebDriver;

public class PasswordField extends FormField {

    public PasswordField(WebDriver driver) {
        super(driver, "password", "user-register-password");

    }

    
}
