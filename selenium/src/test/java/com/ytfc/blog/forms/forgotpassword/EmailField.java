package com.ytfc.blog.forms.forgotpassword;

import com.ytfc.blog.forms.FormField;

import org.openqa.selenium.WebDriver;

public class EmailField extends FormField {

    public EmailField(WebDriver driver) {
        super(driver, "email", "user-forgot-password-email");
    }

    
}
