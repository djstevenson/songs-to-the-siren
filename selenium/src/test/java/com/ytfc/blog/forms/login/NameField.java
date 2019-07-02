package com.ytfc.blog.forms.login;

import com.ytfc.blog.forms.FormField;

import org.openqa.selenium.WebDriver;

public class NameField extends FormField {

    public NameField(WebDriver driver) {
        super(driver, "text", "user-login-name");
    }

    
}
