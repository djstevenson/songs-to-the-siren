package com.ytfc.blog.forms.registration;

import com.ytfc.blog.forms.FormField;

import org.openqa.selenium.WebDriver;

public class EmailField extends FormField {

    public EmailField(WebDriver driver) {
        super(driver, "email", "register-user-email");
    }

    
}
