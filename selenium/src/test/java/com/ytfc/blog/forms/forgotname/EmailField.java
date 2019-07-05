package com.ytfc.blog.forms.forgotname;

import com.ytfc.blog.forms.FormField;

import org.openqa.selenium.WebDriver;

public class EmailField extends FormField {

    public EmailField(WebDriver driver) {
        super(driver, "email", "user-forgot-name-email");
    }

    
}
